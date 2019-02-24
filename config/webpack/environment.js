const { environment } = require('@rails/webpacker');
const erb = require('./loaders/erb');
const webpack = require('webpack');

environment.config.merge({
  resolve: {
    alias: {
      // jquery: 'theme/vendor/jquery/dist/jquery',
    },
  },
});

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    // jQuery: 'jquery',
  })
);

environment.loaders.append('erb', erb);
module.exports = environment;
