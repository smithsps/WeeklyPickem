const CopyWebpackPlugin = require('copy-webpack-plugin')

module.exports = {
    mode: "development",
    devtool: 'source-map',
    entry: './src/main.bs.js',
    plugins: [
        new CopyWebpackPlugin([
            {from: 'static', to: '', force: true},
        ]),
    ],
    output: {
        library: "App"
    }
};
