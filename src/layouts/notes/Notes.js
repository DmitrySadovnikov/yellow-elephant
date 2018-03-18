import React, { Component } from 'react';
import SimpleModalWrapped from '../../components/SimpleModalWrapped';
import ButtonAdd from '../../components/ButtonAdd';

class Notes extends Component {
  render() {
    return (
      <div className={ 'notes' }>
        <div>lol</div>
        <ButtonAdd onClick={this.handleOpen}/>
        <SimpleModalWrapped/>
      </div>
    );
  }
}

export default Notes;
