pragma solidity ^0.4.19;

contract Ethnote {

  // events

  event NoteCreated(
  uint notebook_index,
  address user,
  string title,
  string content,
  uint created_at,
  uint updated_at
  );

  event NotebookCreated(
  address user,
  string title,
  uint created_at,
  uint updated_at
  );

  // structs

  struct Notebook {
  address user;
  string title;
  uint created_at;
  uint updated_at;
  }

  struct Note {
  uint notebook_index;
  address user;
  string title;
  string content;
  uint created_at;
  uint updated_at;
  }

  address public current_user;

  uint public price;

  mapping (address => Notebook []) public notebooksByUser;
  mapping (uint => Note []) public notesByNotebookIndex;

  modifier hasEnoughMoney() {
    require(msg.value >= price);
    _;
  }

  function Ethnote(uint _price) public payable {
    require(_price > 0);
    current_user = msg.sender;
    price = _price;
  }

  function getNotebook(uint _notebook_index) public view returns (
  address user,
  string title,
  uint created_at,
  uint updated_at
  ) {
    Notebook memory notebook = notebooksByUser[current_user][_notebook_index];
    return notebookPresenter(notebook);
  }

  function getNotebookIds() public view returns (uint []) {
    Notebook [] memory notebooks = notebooksByUser[current_user];
    uint [] storage result;

    for (uint i = 0; i < notebooks.length; i++) {
      result.push(i);
    }

    return result;
  }

  function getNote(uint _notebook_index, uint _note_index) public view returns (
  uint notebook_index,
  address user,
  string title,
  uint created_at,
  uint updated_at
  ) {
    Note [] memory notes = notesByNotebookIndex[_notebook_index];
    Note memory current_note = notes[_note_index];

    return notePresenter(current_note);
  }

  function getNoteIds(uint _notebook_index) public view returns (uint []) {
    Note [] memory notes = notesByNotebookIndex[_notebook_index];
    uint [] storage result;

    for (uint i = 0; i < notes.length; i++) {
      result.push(i);
    }

    return result;
  }

  function createNote(
  string _title,
  string _content,
  uint   _notebook_index
  )
  payable public hasEnoughMoney
  returns (
  uint notebook_index,
  address user,
  string title,
  uint created_at,
  uint updated_at
  )
  {
    Notebook memory notebook;

    if (_notebook_index == 0) {
      _notebook_index = createNotebook('inbox');
    }

    Note memory note;
    note.notebook_index = _notebook_index;
    note.user = current_user;
    note.title = _title;
    note.content = _content;
    note.created_at = block.timestamp;
    note.updated_at = block.timestamp;

    notesByNotebookIndex[_notebook_index].push(note);

    NoteCreated(
    note.notebook_index,
    note.user,
    note.title,
    note.content,
    note.created_at,
    notebook.updated_at
    );

    return notePresenter(note);
  }

  function createNotebook(string _title) payable public hasEnoughMoney returns (uint index) {
    Notebook memory notebook;
    notebook.user = current_user;
    notebook.title = _title;
    notebook.created_at = block.timestamp;
    notebook.updated_at = block.timestamp;

    notebooksByUser[current_user].push(notebook);

    NotebookCreated(
    notebook.user,
    notebook.title,
    notebook.created_at,
    notebook.updated_at
    );

    return notebooksByUser[current_user].length - 1;
  }

  function notePresenter(Note note) internal pure returns (
  uint notebook_index,
  address user,
  string title,
  uint created_at,
  uint updated_at
  ) {
    return (
    note.notebook_index,
    note.user,
    note.title,
    note.created_at,
    note.updated_at
    );
  }

  function notebookPresenter(Notebook notebook) internal pure returns (
  address user,
  string title,
  uint created_at,
  uint updated_at
  ) {
    return (
    notebook.user,
    notebook.title,
    notebook.created_at,
    notebook.updated_at
    );
  }
}
