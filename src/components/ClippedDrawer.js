import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from 'material-ui/styles';
import Drawer from 'material-ui/Drawer';
import List from 'material-ui/List';
import Divider from 'material-ui/Divider';
import { mailFolderListItems, otherMailFolderListItems } from './tileData';
import NetworkInfo from './NetworkInfo';
import { ContractData, ContractForm } from 'drizzle-react-components'
import Typography from 'material-ui/Typography';

const drawerWidth = 240;

const styles = theme => ({
  root:        {
    flexGrow: 1,
    height:   '100%',
    zIndex:   1,
    overflow: 'hidden',
    position: 'fixed',
    display:  'flex',
  },
  appBar:      {
    zIndex: theme.zIndex.drawer + 1,
  },
  drawerPaper: {
    position: 'relative',
    width:    drawerWidth,
  },
  content:     {
    flexGrow:        1,
    backgroundColor: theme.palette.background.default,
    padding:         theme.spacing.unit * 3,
    minWidth:        0, // So the Typography noWrap works
  },
  toolbar:     theme.mixins.toolbar,
});

function ClippedDrawer(props) {
  const { classes } = props;

  return (
    <div className={ classes.root }>
      <Drawer
        variant="permanent"
        classes={ {
          paper: classes.drawerPaper,
        } }
      >
        <div className={ classes.toolbar }/>
        <div style={ { padding: '24px' } }>
          <Typography variant="subheading" id="notebooks-count">
            Notebooks <ContractData contract="Ethnote"
                                    method="getNotebooksCount"/>
          </Typography>
        </div>
        <List>{ mailFolderListItems }</List>
        <Divider/>
        <List>{ otherMailFolderListItems }</List>
        <NetworkInfo/>
      </Drawer>
    </div>
  );
}

ClippedDrawer.propTypes = {
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(ClippedDrawer);
