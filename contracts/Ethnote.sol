pragma solidity ^0.4.18;

contract Ethnote {

  // events

  event NoteCreated(
  uint id,
  uint notebook_id,
  address user,
  string title,
  string content,
  uint created_at,
  uint updated_at,
  uint deleted_at
  );

  event NotebookCreated(
  uint id,
  address user,
  string title,
  uint created_at,
  uint updated_at,
  uint deleted_at
  );

  event NoteDeleted(
  uint id,
  uint notebook_id,
  address user,
  uint deleted_at
  );

  event NotebookDeleted(
  uint id,
  address user,
  uint deleted_at
  );

  // structs

  struct Notebook {
  address user;
  string title;
  uint created_at;
  uint updated_at;
  uint deleted_at;
  }

  struct Note {
  uint notebook_id;
  address user;
  string title;
  string content;
  uint created_at;
  uint updated_at;
  uint deleted_at;
  }

  address public current_user;

  uint public price;

  mapping (address => Notebook []) private notebooksByUser;

  mapping (uint => Note []) private notesByNotebookid;

  mapping (address => uint) private userNotebooksCount;

  mapping (uint => uint) private notebookNotesCount;

  modifier hasEnoughMoney() {
    require(msg.value >= price);
    _;
  }

  function Ethnote(uint _price) public payable {
    require(_price > 0);
    current_user = msg.sender;
    price = _price;
  }

  function getNotebook(uint _notebook_id) public view returns (
  address user,
  string title,
  uint created_at,
  uint updated_at,
  uint deleted_at
  ) {
    Notebook memory notebook = notebooksByUser[current_user][_notebook_id];
    return notebookPresenter(notebook);
  }

  function getNotebookNotesCount(uint _notebook_id) public view returns (uint) {
    return notebookNotesCount[_notebook_id];
  }

  function getNotebooksCount() public view returns (uint) {
    return notebooksByUser[msg.sender].length;
  }

  function getNote(uint _notebook_id, uint _note_id) public view returns (
  uint notebook_id,
  address user,
  string title,
  string content,
  uint created_at,
  uint updated_at,
  uint deleted_at
  ) {
    Note [] memory notes = notesByNotebookid[_notebook_id];
    Note memory current_note = notes[_note_id];

    return notePresenter(current_note);
  }

  function createNote(
  string _title,
  string _content,
  uint   _notebook_id
  )
  payable public hasEnoughMoney
  returns (uint)
  {
    Notebook memory notebook;

    if (_notebook_id == 0) {
      if (getNotebooksCount() == 0) {
        _notebook_id = createNotebook('inbox');
      }
    }

    Note memory note;
    note.notebook_id = _notebook_id;
    note.user = current_user;
    note.title = _title;
    note.content = _content;
    note.created_at = block.timestamp;
    note.updated_at = block.timestamp;

    notesByNotebookid[_notebook_id].push(note);
    uint id = notebookNotesCount[_notebook_id];
    notebookNotesCount[_notebook_id] = id + 1;

    NoteCreated(
    id,
    note.notebook_id,
    note.user,
    note.title,
    note.content,
    note.created_at,
    notebook.updated_at,
    notebook.deleted_at
    );

    return id;
  }

  function createNotebook(string _title) payable public hasEnoughMoney returns (uint id) {
    Notebook memory notebook;
    notebook.user = current_user;
    notebook.title = _title;
    notebook.created_at = block.timestamp;
    notebook.updated_at = block.timestamp;

    notebooksByUser[current_user].push(notebook);
    uint id = userNotebooksCount[current_user];
    userNotebooksCount[current_user] = id + 1;

    NotebookCreated(
    id,
    notebook.user,
    notebook.title,
    notebook.created_at,
    notebook.updated_at,
    notebook.deleted_at
    );

    return id;
  }

  function deleteNotebook(uint _id) payable external hasEnoughMoney {
    Notebook storage notebook = notebooksByUser[current_user][_id];
    notebook.deleted_at = block.timestamp;

    NotebookDeleted(_id, notebook.user, notebook.deleted_at);
  }

  function notePresenter(Note note) internal pure returns (
  uint notebook_id,
  address user,
  string title,
  string content,
  uint created_at,
  uint updated_at,
  uint deleted_at
  ) {
    return (
    note.notebook_id,
    note.user,
    note.title,
    note.content,
    note.created_at,
    note.updated_at,
    note.deleted_at
    );
  }

  function notebookPresenter(Notebook notebook) internal pure returns (
  address user,
  string title,
  uint created_at,
  uint updated_at,
  uint deleted_at
  ) {
    return (
    notebook.user,
    notebook.title,
    notebook.created_at,
    notebook.updated_at,
    notebook.deleted_at
    );
  }
}
