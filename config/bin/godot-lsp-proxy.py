#!/usr/bin/env python3
#
# godot-lsp-proxy
#
# TCP proxy that sits between vim (YCM) and Godot's built-in GDScript
# language server, rewriting malformed file URIs on the fly.
#
# THE PROBLEM
#
#   YCM (ycmd) sends LSP document URIs without any slash in protocol:
#
#       file:/home/user/project/script.gd
#       ^^^^^
#       prefix 'file:'
#
#   The LSP spec (RFC 3986) requires two slashes after protocol:
#
#       file:///home/user/project/script.gd
#       ^^^^^^^
#       prefix 'file://'
#
#   Most language servers are lenient about this, but Godot 4.5+ is
#   strict and rejects single-slash URIs with:
#
#       ERROR: LSP: The language server only supports the file protocol
#
#   This causes the LSP handshake to fail and Godot drops the
#   connection. YCM then reports "godotCompleter not running" and you
#   get zero autocompletion, jump-to-definition, or diagnostics.
#
#   As of 2025-04, there is no config on either side to fix this:
#     - YCM has no setting to control URI format
#     - Godot has no setting to relax URI validation
#
# THE FIX
#
#   This proxy listens on a local port (default 6015), and for every
#   LSP message FROM the editor TO Godot, rewrites:
#
#       "file:/home/...   ->   "file:///home/...
#
#   Messages are parsed as proper LSP (Content-Length header + JSON
#   body), so the Content-Length is recalculated after rewriting to
#   keep the protocol valid.
#
#   Messages from Godot back to the editor are passed through
#   unmodified (Godot sends correct triple-slash URIs).
#
# USAGE
#
#   godot-lsp-proxy [listen_port] [godot_port]
#
#   defaults: listen on 6015, forward to 6005
#
#   Point YCM at the proxy port (6015) instead of Godot's port (6005)
#   in your vim config:
#
#       let g:ycm_language_server += [
#           \ { 'name': 'godot',
#           \   'filetypes': ['gdscript'],
#           \   'project_root_files': ['project.godot'],
#           \   'port': 6015 }
#           \ ]
#
# REMOVAL
#
#   When YCM or Godot fixes the URI handling on their end, delete
#   this script and point YCM back at port 6005 directly.
#
import socket
import threading
import re
import sys

LISTEN_PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 6015
GODOT_PORT = int(sys.argv[2]) if len(sys.argv) > 2 else 6005


def fix_uri(data: bytes) -> bytes:
    return re.sub(rb'"file:/([^/])', rb'"file:///\1', data)


def read_message(sock):
    header = b''
    while b'\r\n\r\n' not in header:
        chunk = sock.recv(1)
        if not chunk:
            return None
        header += chunk

    match = re.search(rb'Content-Length: (\d+)', header)
    if not match:
        return None
    length = int(match.group(1))

    body = b''
    while len(body) < length:
        chunk = sock.recv(length - len(body))
        if not chunk:
            return None
        body += chunk

    return body


def send_message(sock, body: bytes):
    header = f'Content-Length: {len(body)}\r\n\r\n'.encode()
    sock.sendall(header + body)


def relay(src, dst, label='', transform=None):
    try:
        while True:
            body = read_message(src)
            if body is None:
                break
            if transform:
                body = transform(body)
            send_message(dst, body)
    except Exception as e:
        print(f'  [{label}] connection closed ({e})')
    finally:
        try:
            src.close()
        except Exception:
            pass
        try:
            dst.close()
        except Exception:
            pass
    print(f'  [{label}] relay stopped')


def print_banner():
    print()
    print('  godot-lsp-proxy')
    print('  ===============')
    print()
    print('  Workaround for YCM sending malformed file URIs to Godot.')
    print()
    print(f'    vim (YCM) -> :{LISTEN_PORT} [rewrite file: -> file://] -> :{GODOT_PORT} (Godot LSP)')
    print(f'    vim (YCM) <- :{LISTEN_PORT} [passthrough]              <- :{GODOT_PORT} (Godot LSP)')
    print()
    print('  Waiting for YCM to connect...')
    print()


def main():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind(('127.0.0.1', LISTEN_PORT))
    server.listen(1)

    print_banner()

    while True:
        client, addr = server.accept()
        print(f'  YCM connected from {addr[0]}:{addr[1]}')

        try:
            godot = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            godot.connect(('127.0.0.1', GODOT_PORT))
            print(f'  Connected to Godot LSP on :{GODOT_PORT}')
            print('  Proxying LSP messages (ctrl-c to stop)')
            print()
        except ConnectionRefusedError:
            print(f'  ERROR: Godot LSP not available on :{GODOT_PORT}')
            print(f'         Is Godot running with the project open?')
            print()
            client.close()
            continue

        threading.Thread(
            target=relay, args=(client, godot, 'ycm->godot', fix_uri),
            daemon=True,
        ).start()
        threading.Thread(
            target=relay, args=(godot, client, 'godot->ycm'),
            daemon=True,
        ).start()


if __name__ == '__main__':
    main()
