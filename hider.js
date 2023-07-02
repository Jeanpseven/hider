const fs = require('fs');
const readline = require('readline');
const path = require('path');
const crypto = require('crypto');

function generateKey() {
  const key = crypto.randomBytes(32);
  fs.writeFileSync('key.key', key);
  console.log('Chave criptográfica gerada com sucesso!');
}

function encryptFile(filePath, key) {
  const fileData = fs.readFileSync(filePath);
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
  const encryptedData = Buffer.concat([cipher.update(fileData), cipher.final()]);
  const encryptedFilePath = filePath + '.enc';
  fs.writeFileSync(encryptedFilePath, iv);
  fs.appendFileSync(encryptedFilePath, encryptedData);
  console.log(`Arquivo '${filePath}' criptografado com sucesso.`);
  fs.unlinkSync(filePath);
}

function decryptFile(filePath, key) {
  const encryptedData = fs.readFileSync(filePath);
  const iv = encryptedData.slice(0, 16);
  const decipher = crypto.createDecipheriv('aes-256-cbc', key, iv);
  const decryptedData = Buffer.concat([decipher.update(encryptedData.slice(16)), decipher.final()]);
  const decryptedFilePath = filePath.slice(0, -4);
  fs.writeFileSync(decryptedFilePath, decryptedData);
  console.log(`Arquivo '${filePath}' descriptografado com sucesso.`);
  fs.unlinkSync(filePath);
}

function encryptImagesInDirectory(directoryPath, key) {
  const files = fs.readdirSync(directoryPath, { withFileTypes: true });

  for (const file of files) {
    const filePath = path.join(directoryPath, file.name);
    if (file.isFile() && /\.(jpg|jpeg|png|gif|img)$/i.test(file.name)) {
      encryptFile(filePath, key);
    }
  }
}

function decryptImagesInDirectory(directoryPath, key) {
  const files = fs.readdirSync(directoryPath, { withFileTypes: true });

  for (const file of files) {
    const filePath = path.join(directoryPath, file.name);
    if (file.isFile() && /\.enc$/i.test(file.name)) {
      decryptFile(filePath, key);
    }
  }
}

function main() {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  console.log('Escolha uma opção:');
  console.log('1. Gerar chave criptográfica');
  console.log('2. Criptografar imagens na pasta Pictures');
  console.log('3. Criptografar imagens na pasta DCIM');
  console.log('4. Criptografar todas as imagens (Pictures e DCIM)');
  console.log('5. Descriptografar imagens na pasta Pictures');
  console.log('6. Descriptografar imagens na pasta DCIM');
  console.log('7. Descriptografar todas as imagens (Pictures e DCIM)');

  rl.question('Opção: ', choice => {
    if (choice === '1') {
      generateKey();
    } else if (choice === '2') {
      const directoryPath = path.join(process.env.HOME, 'Pictures');
      rl.question('Digite a chave de criptografia: ', key => {
        encryptImagesInDirectory(directoryPath, key);
        rl.close();
      });
    } else if (choice === '3') {
      const directoryPath = path.join(process.env.HOME, 'DCIM');
      rl.question('Digite a chave de criptografia: ', key => {
        encryptImagesInDirectory(directoryPath, key);
        rl.close();
      });
    } else if (choice === '4') {
      const picturesDirectoryPath = path.join(process.env.HOME, 'Pictures');
      const dcimDirectoryPath = path.join(process.env.HOME, 'DCIM');
      rl.question('Digite a chave de criptografia: ', key => {
        encryptImagesInDirectory(picturesDirectoryPath, key);
        encryptImagesInDirectory(dcimDirectoryPath, key);
        rl.close();
      });
    } else if (choice === '5') {
      const directoryPath = path.join(process.env.HOME, 'Pictures');
      rl.question('Digite a chave de descriptografia: ', key => {
        decryptImagesInDirectory(directoryPath, key);
        rl.close();
      });
    } else if (choice === '6') {
      const directoryPath = path.join(process.env.HOME, 'DCIM');
      rl.question('Digite a chave de descriptografia: ', key => {
        decryptImagesInDirectory(directoryPath, key);
        rl.close();
      });
    } else if (choice === '7') {
      const picturesDirectoryPath = path.join(process.env.HOME, 'Pictures');
      const dcimDirectoryPath = path.join(process.env.HOME, 'DCIM');
      rl.question('Digite a chave de descriptografia: ', key => {
        decryptImagesInDirectory(picturesDirectoryPath, key);
        decryptImagesInDirectory(dcimDirectoryPath, key);
        rl.close();
      });
    } else {
      console.log('Opção inválida.');
      rl.close();
    }
  });
}

main();
