const path = require('node:path');
const { readCatalog } = require('./native-catalog');
const { publishLibrary } = require('./native-library');

async function main(args) {
    if (args.length !== 2) {
        throw new Error('Usage: node src/native-cli.js /path/native_catalog.json /path/generated-libraries');
    }
    const controller = new AbortController();
    const cancel = () => controller.abort();
    process.once('SIGINT', cancel);
    try {
        const options = { signal: controller.signal };
        const catalog = await readCatalog(path.resolve(args[0]), options);
        const library = await publishLibrary(catalog, path.resolve(args[1]), options);
        console.log(JSON.stringify(library, null, 2));
    } finally {
        process.removeListener('SIGINT', cancel);
    }
}

if (require.main === module) {
    main(process.argv.slice(2)).catch((error) => {
        console.error(error.message);
        process.exitCode = error.name === 'AbortError' ? 130 : 1;
    });
}

module.exports = { main };
