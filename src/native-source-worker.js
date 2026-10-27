const { parentPort, workerData } = require('node:worker_threads');
const { parseSource } = require('./native-source-parser');
parseSource(workerData.text, workerData.knownNames).then(
    (value) => parentPort.postMessage({ value }),
    () => parentPort.postMessage({ value: { declared: [], members: [], parseFailed: true } })
);
