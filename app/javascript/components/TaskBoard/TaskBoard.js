import React, { useEffect, useState } from 'react';
import KanbanBoard from '@asseinfo/react-kanban';
import { propOr } from 'ramda';

import Fab from '@material-ui/core/Fab';
import AddIcon from '@material-ui/icons/Add';

import Task from '../Task';
import TasksRepository from '../../repositories/TasksRepository';
import ColumnHeader from '../ColumnHeader';
import TaskForm from '../../forms/TaskForm';
import AddPopup from '../AddPopup';
import EditPopup from '../EditPopup';

import useStyles from './useStyles';

const STATES = [
  { key: 'new_task', value: 'New' },
  { key: 'in_development', value: 'In Dev' },
  { key: 'in_qa', value: 'In QA' },
  { key: 'in_code_review', value: 'in CR' },
  { key: 'ready_for_release', value: 'Ready for release' },
  { key: 'released', value: 'Released' },
  { key: 'archived', value: 'Archived' },
];

const MODES = {
  ADD: 'add',
  EDIT: 'edit',
  NONE: 'none',
};

const initialBoard = {
  columns: STATES.map((column) => ({
    id: column.key,
    title: column.value,
    cards: [],
    meta: {},
  })),
};

function TaskBoard() {
  const [board, setBoard] = useState(initialBoard);
  const [boardCards, setBoardCards] = useState({});
  const [mode, setMode] = useState(MODES.NONE);
  const [openedTaskId, setOpenedTaskId] = useState(null);
  const styles = useStyles();

  // eslint-disable-next-line no-use-before-define
  useEffect(() => loadBoard(), []);
  // eslint-disable-next-line no-use-before-define
  useEffect(() => generateBoard(), [boardCards]);

  const loadColumn = (state, page, perPage) =>
    TasksRepository.index({
      q: { stateEq: state },
      page,
      perPage,
    });

  const loadColumnInitial = (state, page = 1, perPage = 10) => {
    loadColumn(state, page, perPage).then(({ data }) => {
      setBoardCards((prevState) => ({
        ...prevState,
        [state]: { cards: data.items, meta: data.meta },
      }));
    });
  };

  const loadColumnMore = (state, page = 1, perPage = 10) => {
    loadColumn(state, page, perPage).then(({ data }) => {
      setBoardCards((prevState) => ({
        ...prevState,
        [state]: {
          cards: [...(prevState[state]?.cards || []), ...(data?.items || [])],
          meta: data?.meta || {},
        },
      }));
    });
  };

  const generateBoard = () => {
    const newBoard = {
      columns: STATES.map(({ key, value }) => ({
        id: key,
        title: value,
        cards: propOr([], 'cards', boardCards[key]),
        meta: propOr({}, 'meta', boardCards[key]),
      })),
    };

    setBoard(newBoard);
  };

  const loadBoard = () => {
    STATES.map(({ key }) => loadColumnInitial(key));
  };

  const handleCardDragEnd = (task, source, destination) => {
    const transition = task.transitions.find(({ to }) => destination.toColumnId === to);
    if (!transition) {
      return null;
    }

    return TasksRepository.update(task.id, { task: { stateEvent: transition.event } })
      .then(() => {
        loadColumnInitial(destination.toColumnId);
        loadColumnInitial(source.fromColumnId);
      })
      .catch((error) => {
        // eslint-disable-next-line no-alert
        alert(`Move failed! ${error.message}`);
      });
  };

  const handleAddPopupOpen = () => {
    setMode(MODES.ADD);
  };

  const handleClose = () => {
    setMode(MODES.NONE);
    setOpenedTaskId(null);
  };

  const handleTaskCreate = (params) => {
    const attributes = TaskForm.attributesToSubmit(params);
    return TasksRepository.create({ task: attributes }).then(({ data }) => {
      loadColumnInitial(data.task.state);
      handleClose();
    });
  };

  const loadTask = (id) => TasksRepository.show(id).then(({ data: { task } }) => task);

  const handleTaskUpdate = (task) => {
    const attributes = TaskForm.attributesToSubmit(task);

    return TasksRepository.update(task.id, attributes).then(() => {
      loadColumnInitial(task.state);
      handleClose();
    });
  };

  const handleTaskDestroy = (task) =>
    TasksRepository.destroy(task.id).then(() => {
      loadColumnInitial(task.state);
      handleClose();
    });

  const handleEditPopupOpen = (task) => {
    setOpenedTaskId(task.id);
    setMode(MODES.EDIT);
  };

  return (
    <div>
      <KanbanBoard
        renderColumnHeader={(column) => <ColumnHeader column={column} onLoadMore={loadColumnMore} />}
        renderCard={(card) => <Task onClick={handleEditPopupOpen} task={card} />}
        onCardDragEnd={handleCardDragEnd}
      >
        {board}
      </KanbanBoard>
      <Fab className={styles.addButton} onClick={handleAddPopupOpen} color="primary" aria-label="add">
        <AddIcon />
      </Fab>
      {mode === MODES.ADD && <AddPopup onCardCreate={handleTaskCreate} onClose={handleClose} />}
      {mode === MODES.EDIT && (
        <EditPopup
          onCardLoad={loadTask}
          onCardDestroy={handleTaskDestroy}
          onCardUpdate={handleTaskUpdate}
          onClose={handleClose}
          cardId={openedTaskId}
        />
      )}
    </div>
  );
}

export default TaskBoard;
