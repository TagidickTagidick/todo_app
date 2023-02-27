import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/todo/todo_model.dart';
import '../../../utils/constants/todo_colors.dart';
import '../../bloc/todo_bloc.dart';
import '../widgets/my_sliver_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/my_todo_list_tile.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key, required this.handleItemTapped}) : super(key: key);

  final Function(TodoModel?) handleItemTapped;

  @override
  TodoScreenState createState() => TodoScreenState();
}

class TodoScreenState extends State<TodoScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(InitTodo(context: context));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void submit(String value) {
    context.read<TodoBloc>().add(Submit(
        text: value,
        importance: "low",
        deadline: null
    ));
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final TodoColors todoColors = Theme.of(context).extension<TodoColors>()!;
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: todoColors.backPrimary,
            body: SafeArea(
                child: BlocBuilder<TodoBloc, TodoState>(
                  buildWhen: (oldState, newState) => oldState.isVisible != newState.isVisible
                      || oldState.todoListModel != newState.todoListModel,
                  builder: (context, state) => CustomScrollView(
                      slivers: [
                        SliverPersistentHeader(
                            pinned: true,
                            delegate: MySliverAppBar(
                                onTap: () => context.read<TodoBloc>().add(const VisibilityChanged()),
                                isVisible: state.isVisible,
                                count: state.todoListModel.list.where((element) => element.done).length
                            )
                        ),
                        SliverToBoxAdapter(
                            child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: todoColors.backSecondary,
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Column(
                                    children: [
                                      for (int i = 0; i < state.todoListModel.list.length; i++)
                                        if (state.isVisible || !state.todoListModel.list[i].done)
                                          MyTodoListTile(
                                              todoModel: state.todoListModel.list[i],
                                            handleItemTapped: widget.handleItemTapped
                                          ),
                                      TextField(
                                          controller: controller,
                                          focusNode: FocusNode(),
                                          keyboardType: TextInputType.text,
                                          maxLines: null,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: todoColors.labelPrimary
                                          ),
                                          decoration: InputDecoration(
                                              enabledBorder: const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.transparent
                                                  )
                                              ),
                                              focusedBorder: const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.transparent
                                                  )
                                              ),
                                              hintText: AppLocalizations.of(context)!.newTodo,
                                              hintStyle: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: todoColors.labelTertiary
                                              ),
                                              contentPadding: const EdgeInsets.only(
                                                  left: 52,
                                                  right: 16
                                              )
                                          ),
                                          onSubmitted: submit
                                      )
                                    ]
                                )
                            )
                        )
                      ]
                  )
                )
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => widget.handleItemTapped(null),
                child: const Icon(Icons.add)
            )
        )
    );
  }
}