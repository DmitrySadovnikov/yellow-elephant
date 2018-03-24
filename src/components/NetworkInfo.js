import React, { Component } from 'react';
import getWeb3 from '../util/web3/getWeb3.js';

class NetworkInfo extends Component {
  constructor(props) {
    super(props);

    this.state = {
      web3:                       null,
      submitFormDisplayed:        false,
      fetchFormDisplayed:         false,
      recentSubmissionsDisplayed: false,
    };
  }

  componentWillMount() {
    this.setupWeb3((err) => {
      if (err) {
        return console.log(err);
      }
    });
  }

  setupWeb3(cb) {
    this.setState({ loadingWeb3: true, });
    getWeb3.then(results => {
      let web3 = results.web3;

      if (!web3) {
        console.log('unknown');

        return this.setState({
          loadingWeb3: false,
          network:     'Unknown',
          web3:        null,
        });
      }

      let networkName;
      web3.version.getNetwork((err, networkId) => {
        switch (networkId) {
          case '1':
            networkName = 'Main';
            break;
          case '2':
            networkName = 'Morden';
            break;
          case '3':
            networkName = 'Ropsten';
            break;
          case '4':
            networkName = 'Rinkeby';
            break;
          case '42':
            networkName = 'Kovan';
            break;
          default:
            networkName = 'Unknown';
        }

        console.log(networkName);

        this.setState({
          loadingWeb3: false,
          web3:        web3,
          networkName: networkName,
        });
        cb();
      });
    }).catch((err) => {
      this.setState({ loadingWeb3: false });
      console.log('Error finding web3.', err.message);
    });
  }

  render() {
    return (
      <div className="App">
        <div>
        </div>
      </div>
    );
  }
}

export default NetworkInfo;
