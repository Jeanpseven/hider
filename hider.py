import os
from cryptography.fernet import Fernet

def generate_key():
    key = Fernet.generate_key()
    with open('key.key', 'wb') as key_file:
        key_file.write(key)
    print("Chave criptográfica gerada com sucesso!")

def encrypt_file(file_path, key):
    with open(file_path, 'rb') as file:
        file_data = file.read()
    fernet = Fernet(key)
    encrypted_data = fernet.encrypt(file_data)
    with open(file_path, 'wb') as encrypted_file:
        encrypted_file.write(encrypted_data)
    print(f"Arquivo '{file_path}' criptografado com sucesso.")

def encrypt_file_with_bak_extension(file_path):
    new_file_path = file_path + '.bak'
    os.rename(file_path, new_file_path)
    print(f"Arquivo '{file_path}' renomeado para '{new_file_path}'.")

def decrypt_file(file_path, key):
    with open(file_path, 'rb') as file:
        encrypted_data = file.read()
    fernet = Fernet(key)
    decrypted_data = fernet.decrypt(encrypted_data)
    with open(file_path, 'wb') as decrypted_file:
        decrypted_file.write(decrypted_data)
    print(f"Arquivo '{file_path}' descriptografado com sucesso.")

def decrypt_file_with_bak_extension(file_path):
    new_file_path = file_path[:-4]  # Remove a extensão .bak
    os.rename(file_path, new_file_path)
    print(f"Arquivo '{file_path}' renomeado para '{new_file_path}'.")

def encrypt_images_in_directory(directory_path, key, use_bak_extension=False):
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            if file.lower().endswith(('.jpg', '.jpeg', '.png', '.gif', '.img')):
                file_path = os.path.join(root, file)
                if use_bak_extension:
                    encrypt_file_with_bak_extension(file_path)
                else:
                    encrypt_file(file_path, key)

def decrypt_images_in_directory(directory_path, key, use_bak_extension=False):
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            if file.lower().endswith(('.jpg', '.jpeg', '.png', '.gif', '.img')):
                file_path = os.path.join(root, file)
                if use_bak_extension:
                    decrypt_file_with_bak_extension(file_path)
                else:
                    decrypt_file(file_path, key)

def main():
    print("Escolha uma opção:")
    print("1. Gerar chave criptográfica")
    print("2. Criptografar imagens na pasta Pictures")
    print("3. Criptografar imagens na pasta DCIM")
    print("4. Criptografar todas as imagens (Pictures e DCIM) com .bak")
    print("5. Descriptografar imagens na pasta Pictures")
    print("6. Descriptografar imagens na pasta DCIM")
    print("7. Descriptografar todas as imagens (Pictures e DCIM) com .bak")
    choice = input("Opção: ")

    if choice == '1':
        generate_key()
    elif choice == '2':
        directory_path = os.path.expanduser("~/Pictures")
        key = input("Digite a chave de criptografia: ")
        encrypt_images_in_directory(directory_path, key)
    elif choice == '3':
        directory_path = os.path.expanduser("~/DCIM")
        key = input("Digite a chave de criptografia: ")
        encrypt_images_in_directory(directory_path, key)
    elif choice == '4':
        directory_path = os.path.expanduser("~/Pictures")
        key = input("Digite a chave de criptografia: ")
        print("Opção selecionada: Usar extensão '.bak' para criptografia.")
        encrypt_images_in_directory(directory_path, key, use_bak_extension=True)
        directory_path = os.path.expanduser("~/DCIM")
        key = input("Digite a chave de criptografia: ")
        encrypt_images_in_directory(directory_path, key, use_bak_extension=True)
    elif choice == '5':
        directory_path = os.path.expanduser("~/Pictures")
        key = input("Digite a chave de descriptografia: ")
        decrypt_images_in_directory(directory_path, key)
    elif choice == '6':
        directory_path = os.path.expanduser("~/DCIM")
        key = input("Digite a chave de descriptografia: ")
        decrypt_images_in_directory(directory_path, key)
    elif choice == '7':
        directory_path = os.path.expanduser("~/Pictures")
        key = input("Digite a chave de descriptografia: ")
        print("Opção selecionada: Usar extensão '.bak' para descriptografia.")
        decrypt_images_in_directory(directory_path, key, use_bak_extension=True)
        directory_path = os.path.expanduser("~/DCIM")
        key = input("Digite a chave de descriptografia: ")
        decrypt_images_in_directory(directory_path, key, use_bak_extension=True)
    else:
        print("Opção inválida.")

if __name__ == '__main__':
    main()
