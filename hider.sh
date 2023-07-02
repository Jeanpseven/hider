#!/bin/sh

generate_key() {
    python3 - <<END
import os
from cryptography.fernet import Fernet

key = Fernet.generate_key()
with open('key.key', 'wb') as key_file:
    key_file.write(key)
print("Chave criptográfica gerada com sucesso!")
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
print("Arquivo '${file_path}' criptografado com sucesso.")
END
}

encrypt_file_with_bak_extension() {
    python3 - <<END
import os

file_path="$1"
new_file_path="\${file_path}.bak"

os.rename(file_path, new_file_path)
print("Arquivo '${file_path}' renomeado para '${new_file_path}'.")
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
print("Arquivo '${file_path}' descriptografado com sucesso.")
END
}

decrypt_file_with_bak_extension() {
    python3 - <<END
import os

file_path="$1"
new_file_path="\${file_path%.*}"

os.rename(file_path, new_file_path)
print("Arquivo '${file_path}' renomeado para '${new_file_path}'.")
END
}

encrypt_images_in_directory() {
    python3 - <<END
import os

directory_path="$1"
key="$2"
use_bak_extension="$3"

for root, dirs, files in os.walk(directory_path):
    for file in \$files; do
        if [ "\${file,,}" = *.jpg ] || [ "\${file,,}" = *.jpeg ] || [ "\${file,,}" = *.png ] || [ "\${file,,}" = *.gif ] || [ "\${file,,}" = *.img ]; then
            file_path="\${root}/\${file}"
            if [ "\$use_bak_extension" = "true" ]; then
                encrypt_file_with_bak_extension "\$file_path"
            else
                encrypt_file "\$file_path" "\$key"
            fi
        fi
    done
END
}

decrypt_images_in_directory() {
    python3 - <<END
import os

directory_path="$1"
key="$2"
use_bak_extension="$3"

for root, dirs, files in os.walk(directory_path):
    for file in \$files; do
        if [ "\${file,,}" = *.jpg ] || [ "\${file,,}" = *.jpeg ] || [ "\${file,,}" = *.png ] || [ "\${file,,}" = *.gif ] || [ "\${file,,}" = *.img ]; then
            file_path="\${root}/\${file}"
            if [ "\$use_bak_extension" = "true" ]; then
                decrypt_file_with_bak_extension "\$file_path"
            else
                decrypt_file "\$file_path" "\$key"
            fi
        fi
    done
END
}

main() {
    echo "Escolha uma opção:"
    echo "1. Gerar chave criptográfica"
    echo "2. Criptografar imagens na pasta Pictures"
    echo "3. Criptografar imagens na pasta DCIM"
    echo "4. Criptografar todas as imagens (Pictures e DCIM)"
    echo "5. Descriptografar imagens na pasta Pictures"
    echo "6. Descriptografar imagens na pasta DCIM"
    echo "7. Descriptografar todas as imagens (Pictures e DCIM)"
    read -p "Opção: " choice

    if [ "$choice" = "1" ]; then
        generate_key
    elif [ "$choice" = "2" ]; then
        directory_path="$HOME/Pictures"
        key=""
        read -p "Digite a chave de criptografia: " key
        encrypt_images_in_directory "$directory_path" "$key" "false"
    elif [ "$choice" = "3" ]; then
        directory_path="$HOME/DCIM"
        key=""
        read -p "Digite a chave de criptografia: " key
        encrypt_images_in_directory "$directory_path" "$key" "false"
    elif [ "$choice" = "4" ]; then
        directory_path="$HOME/Pictures"
        key=""
        read -p "Digite a chave de criptografia: " key
        encrypt_images_in_directory "$directory_path" "$key" "true"
        directory_path="$HOME/DCIM"
        key=""
        read -p "Digite a chave de criptografia: " key
        encrypt_images_in_directory "$directory_path" "$key" "true"
    elif [ "$choice" = "5" ]; then
        directory_path="$HOME/Pictures"
        key=""
        read -p "Digite a chave de descriptografia: " key
        decrypt_images_in_directory "$directory_path" "$key" "false"
    elif [ "$choice" = "6" ]; then
        directory_path="$HOME/DCIM"
        key=""
        read -p "Digite a chave de descriptografia: " key
        decrypt_images_in_directory "$directory_path" "$key" "false"
    elif [ "$choice" = "7" ]; then
        directory_path="$HOME/Pictures"
        key=""
        read -p "Digite a chave de descriptografia: " key
        decrypt_images_in_directory "$directory_path" "$key" "true"
        directory_path="$HOME/DCIM"
        key=""
        read -p "Digite a chave de descriptografia: " key
        decrypt_images_in_directory "$directory_path" "$key" "true"
    else
        echo "Opção inválida."
    fi
}

main
