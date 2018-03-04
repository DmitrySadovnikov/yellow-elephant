pragma solidity ^0.4.20;

contract Ethnote {

  // events

  event NoteCreated(
    uint id,
    uint notebook_id,
    address user,
    string title,
    string content,
    uint created_at
  );

  event NotebookCreated(
    uint id,
    address user,
    string title,
    uint created_at
  );

  // structs

  struct Notebook {
    uint id;
    address user;
    string title;
    uint created_at;
    uint updated_at;
  }

  struct Note {
    uint id;
    uint notebook_id;
    address user;
    string title;
    string content;
    uint created_at;
    uint updated_at;
  }

  address public current_user;

  uint public price;

  mapping (address => Notebook []) public userNotebooks;

  mapping (uint => Note []) public notebookNotes;

  modifier hasBalance() {
    require(msg.value >= price);
    _;
  }

  function Ethnote(uint _price) public {
    require(_price > 0);
    current_user = msg.sender;
    price = _price;
  }

  function get_notebook(uint _notebook_id) public view returns (Notebook) {
    Notebook [] memory notebooks = get_notebooks();
    Notebook memory notebook;

    for (uint i = 0; i < notebooks.length; i++) {
      notebook = notebooks[i];

      if (notebook.id == _notebook_id) {
        return notebook;
      }
    }
  }

  function get_notebooks() public view returns (Notebook []) {
    return userNotebooks[current_user];
  }

  function get_note(uint _notebook_id, uint _note_id) public view returns (Note) {
    Note [] memory notes = get_notes(_notebook_id);
    Note memory current_note;

    for (uint i = 0; i < notes.length; i++) {
      current_note = notes[i];

      if (current_note.id == _note_id) {
        return current_note;
      }
    }
  }

  function get_notes(uint _notebook_id) public view returns (Note []) {
    return notebookNotes[_notebook_id];
  }

  function create_note(string _title, string _content, uint _notebook_id) payable public hasBalance returns (Note) {
    Notebook memory notebook;

    if (_notebook_id > 0) {
      notebook = get_notebook(_notebook_id);
    }
    else {
      notebook = create_notebook('inbox');
    }

    Note memory note;
    note.id = uint(keccak256(block.timestamp, current_user));
    note.notebook_id = notebook.id;
    note.user = current_user;
    note.title = _title;
    note.content = _content;
    note.created_at = block.timestamp;
    note.updated_at = block.timestamp;

    notebookNotes[notebook.id].push(note);

    NoteCreated(
    note.id,
    note.notebook_id,
    note.user,
    note.title,
    note.content,
    note.created_at
    );

    return note;
  }

  function create_notebook(string _title) payable public hasBalance returns (Notebook) {
    Notebook memory notebook;
    notebook.id = uint(keccak256(block.timestamp, current_user));
    notebook.user = current_user;
    notebook.title = _title;
    notebook.created_at = block.timestamp;
    notebook.updated_at = block.timestamp;

    userNotebooks[current_user].push(notebook);

    NotebookCreated(
    notebook.id,
    notebook.user,
    notebook.title,
    notebook.created_at
    );

    return notebook;
  }

  function delete_note(uint _notebook_id, uint _note_id) public view returns (bool) {
    Note [] memory notes = get_notes(_notebook_id);
    Note memory note;

    for (uint i = 0; i < notes.length; i++) {
      note = notes[i];

      if (note.id == _note_id) {
        delete notes[i];
        return true;
      }
    }

    return false;
  }

  function delete_notebook(uint _notebook_id) public view returns (bool) {
    Notebook [] memory notebooks = get_notebooks();
    Notebook memory notebook;

    for (uint i = 0; i < notebooks.length; i++) {
      notebook = notebooks[i];

      if (notebook.id == _notebook_id) {
        delete notebooks[i];
        return true;
      }
    }

    return false;
  }
}
