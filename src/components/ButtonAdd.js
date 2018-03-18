import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from 'material-ui/styles';
import Button from 'material-ui/Button';
import AddIcon from 'material-ui-icons/Add';

const styles = theme => ({
  button: {
    margin:   theme.spacing.unit,
    position: 'fixed',
    bottom:   '2%',
    right:    '2%',
  },
});

function ButtonAdd(props) {
  const { classes } = props;
  return (
    <div className={classes.root}>
      <Button variant="fab" color="primary" aria-label="add"
              className={ classes.button } onClick={ props.onClick }>
        <AddIcon />
      </Button>
    </div>
  );
}

ButtonAdd.propTypes = {
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(ButtonAdd);
