<?php

function generate_key() {
    $key = \Sodium\randombytes_buf(SODIUM_CRYPTO_SECRETBOX_KEYBYTES);
    file_put_contents('key.key', $key);
    echo "Chave criptográfica gerada com sucesso!" . PHP_EOL;
}

function encrypt_file($file_path, $key) {
    $file_data = file_get_contents($file_path);
    $encrypted_data = sodium_crypto_secretbox($file_data, $nonce, $key);
    file_put_contents($file_path, $encrypted_data);
    echo "Arquivo '{$file_path}' criptografado com sucesso." . PHP_EOL;
}

function decrypt_file($file_path, $key) {
    $encrypted_data = file_get_contents($file_path);
    $decrypted_data = sodium_crypto_secretbox_open($encrypted_data, $nonce, $key);
    file_put_contents($file_path, $decrypted_data);
    echo "Arquivo '{$file_path}' descriptografado com sucesso." . PHP_EOL;
}

function encrypt_images_in_directory($directory_path, $key) {
    $files = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($directory_path));

    foreach ($files as $file) {
        if ($file->isFile()) {
            $file_path = $file->getPathname();
            $extension = strtolower(pathinfo($file_path, PATHINFO_EXTENSION));

            if (in_array($extension, ['jpg', 'jpeg', 'png', 'gif', 'img'])) {
                encrypt_file($file_path, $key);
            }
        }
    }
}

function decrypt_images_in_directory($directory_path, $key) {
    $files = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($directory_path));

    foreach ($files as $file) {
        if ($file->isFile()) {
            $file_path = $file->getPathname();
            $extension = strtolower(pathinfo($file_path, PATHINFO_EXTENSION));

            if (in_array($extension, ['jpg', 'jpeg', 'png', 'gif', 'img'])) {
                decrypt_file($file_path, $key);
            }
        }
    }
}

echo "Escolha uma opção:" . PHP_EOL;
echo "1. Gerar chave criptográfica" . PHP_EOL;
echo "2. Criptografar imagens na pasta Pictures" . PHP_EOL;
echo "3. Criptografar imagens na pasta DCIM" . PHP_EOL;
echo "4. Criptografar todas as imagens (Pictures e DCIM)" . PHP_EOL;
echo "5. Descriptografar imagens na pasta Pictures" . PHP_EOL;
echo "6. Descriptografar imagens na pasta DCIM" . PHP_EOL;
echo "7. Descriptografar todas as imagens (Pictures e DCIM)" . PHP_EOL;
$choice = readline("Opção: ");

if ($choice == '1') {
    generate_key();
} elseif ($choice == '2') {
    $directory_path = $_SERVER['HOME'] . '/Pictures';
    $key = readline("Digite a chave de criptografia: ");
    encrypt_images_in_directory($directory_path, $key);
} elseif ($choice == '3') {
    $directory_path = $_SERVER['HOME'] . '/DCIM';
    $key = readline("Digite a chave de criptografia: ");
    encrypt_images_in_directory($directory_path, $key);
} elseif ($choice == '4') {
    $directory_path = $_SERVER['HOME'] . '/Pictures';
    $key = readline("Digite a chave de criptografia: ");
    encrypt_images_in_directory($directory_path, $key);
    $directory_path = $_SERVER['HOME'] . '/DCIM';
    $key = readline("Digite a chave de criptografia: ");
    encrypt_images_in_directory($directory_path, $key);
} elseif ($choice == '5') {
    $directory_path = $_SERVER['HOME'] . '/Pictures';
    $key = readline("Digite a chave de descriptografia: ");
    decrypt_images_in_directory($directory_path, $key);
} elseif ($choice == '6') {
    $directory_path = $_SERVER['HOME'] . '/DCIM';
    $key = readline("Digite a chave de descriptografia: ");
    decrypt_images_in_directory($directory_path, $key);
} elseif ($choice == '7') {
    $directory_path = $_SERVER['HOME'] . '/Pictures';
    $key = readline("Digite a chave de descriptografia: ");
    decrypt_images_in_directory($directory_path, $key);
    $directory_path = $_SERVER['HOME'] . '/DCIM';
    $key = readline("Digite a chave de descriptografia: ");
    decrypt_images_in_directory($directory_path, $key);
} else {
    echo "Opção inválida." . PHP_EOL;
}

?>
