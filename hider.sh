#!/bin/bash

generate_key() {
    python3 - <<END
import os
from cryptography.fernet import Fernet

key = Fernet.generate_key()
with open('key.key', 'wb') as key_file:
    key_file.write(key)
END
}

encrypt_file() {
    python3 - <<END
import os
from cryptography.fernet import Fernet

file_path="$1"
key="$2"

with open(file_path, 'rb') as file:
    file_data = file.read()
fernet = Fernet(key)
encrypted_data = fernet.encrypt(file_data)
with open(file_path, 'wb') as encrypted_file:
    encrypted_file.write(encrypted_data)
print(f"Arquivo '{file_path}' criptografado com sucesso.")
END
}

encrypt_images_in_directory() {
    python3 - <<END
import os

directory_path="$1"
key="$2"

for root, dirs, files in os.walk(directory_path):
    for file in files:
        if file.lower().endswith(('.img', '.jpg', '.jpeg', '.png', '.gif')):
            file_path = os.path.join(root, file)
            encrypt_file(file_path, key)
END
}

main() {
    echo "Escolha uma opção:"
    echo "1. Criptografar imagens na pasta Pictures"
    echo "2. Criptografar imagens na pasta DCIM"
    echo "3. Criptografar todas as imagens (Pictures e DCIM)"
    read -p "Opção: " choice
    read -p "Digite a chave de criptografia: " key

    if [ "$choice" = "1" ]; then
        encrypt_images_in_directory "$HOME/Pictures" "$key"
    elif [ "$choice" = "2" ]; then
        encrypt_images_in_directory "$HOME/DCIM" "$key"
    elif [ "$choice" = "3" ]; then
        encrypt_images_in_directory "$HOME/Pictures" "$key"
        encrypt_images_in_directory "$HOME/DCIM" "$key"
    else
        echo "Opção inválida."
    fi
}

main
