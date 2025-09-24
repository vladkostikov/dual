import { propEq } from 'ramda';
import { createSlice } from '@reduxjs/toolkit';
import TasksRepository from 'repositories/TasksRepository';
import { STATES } from 'presenters/TaskPresenter';
import { useDispatch } from 'react-redux';
import { changeColumn } from '@asseinfo/react-kanban';

const initialState = {
  board: {
    columns: STATES.map((column) => ({
      id: column.key,
      title: column.value,
      cards: [],
      meta: {},
    })),
  },
};

const tasksSlice = createSlice({
  name: 'tasks',
  initialState,
  reducers: {
    loadColumnSuccess(state, { payload }) {
      const { items, meta, columnId } = payload;
      const columnIndex = state.board.columns.findIndex((column) => column.id === columnId);
      if (columnIndex === -1) return state;

      const column = state.board.columns[columnIndex];

      state.board = changeColumn(state.board, column, {
        cards: items,
        meta,
      });

      return state;
    },
    loadColumnAppendSuccess(state, { payload }) {
      const { items, meta, columnId } = payload;
      const columnIndex = state.board.columns.findIndex((column) => column.id === columnId);
      if (columnIndex === -1) return state;

      const column = state.board.columns[columnIndex];

      state.board = changeColumn(state.board, column, {
        cards: [...column.cards, ...items],
        meta,
      });

      return state;
    },
  },
});

const { loadColumnSuccess, loadColumnAppendSuccess } = tasksSlice.actions;

export default tasksSlice.reducer;

export const useTasksActions = () => {
  const dispatch = useDispatch();

  const loadColumn = (columnId, page = 1, perPage = 10) => {
    TasksRepository.index({
      q: { stateEq: columnId },
      page,
      perPage,
    }).then(({ data }) => {
      dispatch(loadColumnSuccess({ ...data, columnId }));
    });
  };

  const loadColumnMore = (columnId, page = 1, perPage = 10) => {
    TasksRepository.index({
      q: { stateEq: columnId },
      page,
      perPage,
    }).then(({ data }) => {
      dispatch(loadColumnAppendSuccess({ ...data, columnId }));
    });
  };

  const moveTask = (task, source, destination) => {
    const transition = task.transitions?.find(({ to }) => destination.toColumnId === to);
    if (!transition) return Promise.resolve(null);

    return TasksRepository.update(task.id, { task: { stateEvent: transition.event } }).then(() =>
      Promise.all([loadColumn(destination.toColumnId), loadColumn(source.fromColumnId)]),
    );
  };


  const loadBoard = () => STATES.map(({ key }) => loadColumn(key));

  return {
    loadBoard,
    loadColumn,
    loadColumnMore,
    moveTask,
  };
};
