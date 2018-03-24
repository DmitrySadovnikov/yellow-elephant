import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from 'material-ui/styles';
import Typography from 'material-ui/Typography';
import Modal from 'material-ui/Modal';
import { ContractData, ContractForm } from 'drizzle-react-components';
import ButtonAdd from './ButtonAdd';

function rand() {
  return Math.round(Math.random() * 20) - 10;
}

function getModalStyle() {
  const top  = 50 + rand();
  const left = 50 + rand();

  return {
    top:       `${top}%`,
    left:      `${left}%`,
    transform: `translate(-${top}%, -${left}%)`,
  };
}

const styles = theme => ({
  paper: {
    position:        'absolute',
    width:           theme.spacing.unit * 50,
    backgroundColor: theme.palette.background.paper,
    boxShadow:       theme.shadows[5],
    padding:         theme.spacing.unit * 4,
  },
});

class SimpleModal extends React.Component {
  state = {
    open: false,
  };

  handleOpen = () => {
    this.setState({ open: true });
  };

  handleClose = () => {
    this.setState({ open: false });
  };

  render() {
    const { classes } = this.props;

    return (
      <div>
        <ButtonAdd onClick={ this.handleOpen }/>
        <Modal
          aria-labelledby="simple-modal-title"
          aria-describedby="simple-modal-description"
          open={ this.state.open }
          onClose={ this.handleClose }
        >
          <div style={ getModalStyle() } className={ classes.paper }>
            <Typography variant="title" id="modal-title">
              Text in a modal
            </Typography>
            <Typography variant="subheading" id="simple-modal-description">
              Duis mollis, est non commodo luctus, nisi erat porttitor ligula.
            </Typography>
            <p><strong>Stored Value</strong>: <ContractData
              contract="SimpleStorage" method="storedData"/></p>
            <ContractForm contract="Ethnote" method="createNote"/>
          </div>
        </Modal>
      </div>
    );
  }
}

SimpleModal.propTypes = {
  classes: PropTypes.object.isRequired,
};

// We need an intermediary variable for handling the recursive nesting.
const SimpleModalWrapped = withStyles(styles)(SimpleModal);

export default SimpleModalWrapped;
