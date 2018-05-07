const path = require('path')
const webpack = require('webpack')
const env = process.env.MIX_ENV || 'dev'
const isProduction = (env === 'prod')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
  entry: {
    'app': ['./js/app.js', './scss/app.scss'],
  },

  output: {
    path: path.resolve(__dirname, '../priv/static/'),
    filename: 'js/[name].js'
  },

  devtool: 'source-map',

  resolve: {
    extensions: ['*', '.js', '.jsx']
  },

  module: {
    rules: [
      {
        test:/\.(sass|scss)$/,
        use: [
          MiniCssExtractPlugin.loader,
          {loader: 'css-loader'},
          {
            loader: 'sass-loader',
            options: {sourceComments: !isProduction}
          }
        ]
      },
      {
        test: /\.(png|woff|woff2|eot|ttf|svg)$/,
        loader: 'url-loader?limit=100000'
      },
      {
        test: /\.js$/,
        include: /js/,
        use: ['babel-loader']
      }
    ]
  },

  plugins: [
    new MiniCssExtractPlugin({
      filename: "./css/[name].css",
      chunkFilename: "./css/[id].css"
    }),
    new CopyWebpackPlugin([{ from: './static' }]),
  ]
}
