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

decrypt_file() {
    python3 - <<END
import os
from cryptography.fernet import Fernet

file_path="$1"
key="$2"

with open(file_path, 'rb') as file:
    encrypted_data = file.read()
fernet = Fernet(key)
decrypted_data = fernet.decrypt(encrypted_data)
with open(file_path, 'wb') as decrypted_file:
    decrypted_file.write(decrypted_data)
print(f"Arquivo '{file_path}' descriptografado com sucesso.")
END
}

encrypt_files_in_directory() {
    python3 - <<END
import os
from cryptography.fernet import Fernet

directory_path="$1"
key="$2"

for root, dirs, files in os.walk(directory_path):
    for file in files:
        file_path = os.path.join(root, file)
        encrypt_file(file_path, key)
END
}

decrypt_files_in_directory() {
    python3 - <<END
import os
from cryptography.fernet import Fernet

directory_path="$1"
key="$2"

for root, dirs, files in os.walk(directory_path):
    for file in files:
        file_path = os.path.join(root, file)
        decrypt_file(file_path, key)
END
}

main() {
    echo "Escolha uma opção:"
    echo "1. Criptografar arquivos"
    echo "2. Descriptografar arquivos"
    read -p "Opção: " choice
    read -p "Digite o caminho para a pasta: " directory_path
    read -p "Digite a chave de criptografia: " key

    if [ "$choice" = "1" ]; then
        encrypt_files_in_directory "$directory_path" "$key"
    elif [ "$choice" = "2" ]; then
        decrypt_files_in_directory "$directory_path" "$key"
    else
        echo "Opção inválida."
    fi
}

main
