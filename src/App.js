import React, { Component } from 'react';
import SimpleAppBar from './components/SimpleAppBar';
import ClippedDrawer from './components/ClippedDrawer';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import Notes from './layouts/notes/Notes';
import { createMuiTheme } from 'material-ui/styles';
import amber from 'material-ui/colors/amber';
import brown from 'material-ui/colors/brown';

// Styles
import './css/oswald.css';
import './css/open-sans.css';
import './css/pure-min.css';
import './App.css';

const theme = createMuiTheme({
  palette: {
    primary:   { main: amber[500] },
    secondary: { main: brown[500] },
    type:      'dark',
  },
});

class App extends Component {
  render() {
    return (
      <MuiThemeProvider theme={ theme }>
        <div className="App">
          <SimpleAppBar/>
          <div className={ 'rowC' }>
            <ClippedDrawer/>
            <div className={ 'right-side' }>
              <Notes/>
              { this.props.children }
            </div>
          </div>

        </div>
      </MuiThemeProvider>
    );
  }
}

export default App;
