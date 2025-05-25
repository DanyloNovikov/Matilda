const fs = require('fs');
const path = require('path');

class NetworkDefinitor {
  allNetworks() {
    const jsonFilePath = path.resolve(__dirname, '../networks.json');
    const jsonContent = fs.readFileSync(jsonFilePath, 'utf8');
    const processedJson = this.replaceEnvVars(jsonContent);

    return JSON.parse(processedJson).networks;
  }
  
  replaceEnvVars(content) {
    return content.replace(/\$\{([^}]+)\}/g, (match, varName) => {
      return process.env[varName] || '';
    });
  }
}

module.exports = NetworkDefinitor;
