import { createSlice } from '@reduxjs/toolkit';
import TasksRepository from 'repositories/TasksRepository';
import TaskForm from 'forms/TaskForm';
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

  const createTask = (params) => {
    const attributes = TaskForm.attributesToSubmit(params);
    return TasksRepository.create({ task: attributes }).then(({ data }) => {
      if (data?.task?.state) loadColumn(data.task.state);
      return data;
    });
  };

  const loadTask = (id) => TasksRepository.show(id).then(({ data: { task } }) => task);

  const updateTask = (task) => {
    const attributes = TaskForm.attributesToSubmit(task);
    return TasksRepository.update(task.id, attributes).then((response) => {
      if (task?.state) loadColumn(task.state);
      return response;
    });
  };

  const destroyTask = (task) =>
    TasksRepository.destroy(task.id).then((response) => {
      if (task?.state) loadColumn(task.state);
      return response;
    });

  const loadBoard = () => STATES.map(({ key }) => loadColumn(key));

  return {
    loadBoard,
    loadColumn,
    loadColumnMore,
    moveTask,
    createTask,
    loadTask,
    updateTask,
    destroyTask,
  };
};
