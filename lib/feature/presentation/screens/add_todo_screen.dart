import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/todo/todo_model.dart';
import '../../../utils/constants/sized_box_constants.dart';
import '../../../utils/constants/todo_colors.dart';
import '../../bloc/todo_bloc.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({
    Key? key,
    required this.todoModel,
    required this.handleItemTapped,
    required this.save
  }) : super(key: key);

  final TodoModel? todoModel;
  final Function() handleItemTapped;
  final Function(void Function() ) save;

  @override
  AddTodoScreenState createState() => AddTodoScreenState();
}

class AddTodoScreenState extends State<AddTodoScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();

  AnimationController? animationController;

  Locale? locale;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void didChangeDependencies() {
    TodoBloc bloc = context.read<TodoBloc>();
    if (widget.todoModel != null) {
      bloc.add(ImportanceChanged(value: widget.todoModel!.importance));
      controller.text = widget.todoModel!.text;
      if (controller.text.isNotEmpty) {
        bloc.add(const TextChanged(value: true));
      }
      if (widget.todoModel!.deadline != null) {
        animationController?.forward();
        bloc.add(const MakeItToChanged(value: true));
        bloc.add(DateTimeChanged(
            dateTime: DateTime.fromMillisecondsSinceEpoch(widget.todoModel!.deadline!)
        ));
      }
    }
    locale = Localizations.localeOf(context);
    super.didChangeDependencies();
  }

  void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onTextChanged(String value, bool canDelete) {
    if (canDelete) {
      if (value.isEmpty) {
        context.read<TodoBloc>().add(const TextChanged(value: false));
      }
    }
    else {
      if (value.isNotEmpty) {
        context.read<TodoBloc>().add(const TextChanged(value: true));
      }
    }
  }

  void onSwitchChanged(bool value) async {
    if (value) {
      DateTime? dateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2024),
          locale: locale,
          helpText: DateTime.now().year.toString(),
          confirmText: AppLocalizations.of(context)!.done
      );
      if (dateTime == null) {
        context.read<TodoBloc>().add(const MakeItToChanged(value: false));
        animationController?.reverse();
      }
      else {
        context.read<TodoBloc>().add(DateTimeChanged(dateTime: dateTime));
        context.read<TodoBloc>().add(const MakeItToChanged(value: true));
        animationController?.forward();
      }
    }
    else {
      context.read<TodoBloc>().add(MakeItToChanged(value: value));
      animationController?.reverse();
    }
  }

  void delete(TodoModel? todoModel) {
    if (todoModel != null) {
      context.read<TodoBloc>().add(DeleteTodo(id: todoModel.id));
    }
    //context.read<TodoBloc>().add(PopAddTodo());
  }

  @override
  Widget build(BuildContext context) {
    final TodoColors todoColors = Theme.of(context).extension<TodoColors>()!;
    return GestureDetector(
        onTap: unfocus,
        child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) => Scaffold(
                backgroundColor: todoColors.backPrimary,
                appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: GestureDetector(
                        onTap: widget.handleItemTapped,
                        child: Icon(
                            Icons.close,
                            color: todoColors.labelPrimary
                        )
                    ),
                    actions: [
                      Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                              onTap: () => widget.save(() {
                                String importance = "Нет";
                                switch (state.importance) {
                                  case "Нет":
                                    importance = "low";
                                    break;
                                  case "Низкий":
                                    importance = "basic";
                                    break;
                                  case "!! Высокий":
                                    importance = "important";
                                    break;
                                }
                                if (widget.todoModel != null) {
                                  context.read<TodoBloc>().add(EditTodo(
                                      id: widget.todoModel!.id,
                                      text: controller.text,
                                      importance: importance,
                                      deadline: state.makeItTo
                                          ? state.dateTime.toUtc().millisecondsSinceEpoch
                                          : null
                                  ));
                                }
                                else {
                                  context.read<TodoBloc>().add(Submit(
                                      text: controller.text,
                                      importance: importance,
                                      deadline: state.makeItTo
                                          ? state.dateTime.toUtc().millisecondsSinceEpoch
                                          : null
                                  ));
                                }
                              }),
                              child: Text(
                                  AppLocalizations.of(context)!.save,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: todoColors.colorBlue
                                  )
                              )
                          )
                      ),
                      horizontal16
                    ]
                ),
                body: SingleChildScrollView(
                    child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 23,
                                  left: 16,
                                  right: 16,
                                  bottom: 50
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            color: todoColors.backSecondary,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Color.fromARGB(15, 0, 0, 0),
                                                  offset: Offset.zero,
                                                  blurRadius: 2
                                              ),
                                              BoxShadow(
                                                  color: Color.fromARGB(31, 0, 0, 0),
                                                  offset: Offset(0, 2),
                                                  blurRadius: 2
                                              )
                                            ]
                                        ),
                                        child: TextField(
                                            controller: controller,
                                            maxLines: null,
                                            textAlign: TextAlign.start,
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
                                                hintText: AppLocalizations.of(context)!.hintText,
                                                hintStyle: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    color: todoColors.labelTertiary
                                                )
                                            ),
                                            onChanged: (value) => onTextChanged(
                                                value,
                                                state.canDelete
                                            )
                                        )
                                    ),
                                    vertical28,
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          PopupMenuButton<String>(
                                              onSelected: (value) => context.read<TodoBloc>().add(ImportanceChanged(value: value)),
                                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                                PopupMenuItem<String>(
                                                    value: "low",
                                                    child: Text(
                                                        AppLocalizations.of(context)!.low,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 16,
                                                            color: todoColors.labelPrimary
                                                        )
                                                    )
                                                ),
                                                PopupMenuItem<String>(
                                                    value: "basic",
                                                    child: Text(
                                                        AppLocalizations.of(context)!.basic,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 16,
                                                            color: todoColors.labelPrimary
                                                        )
                                                    )
                                                ),
                                                PopupMenuItem<String>(
                                                    value: "important",
                                                    child: Text(
                                                        AppLocalizations.of(context)!.important,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 16,
                                                            color: todoColors.colorRed
                                                        )
                                                    )
                                                )
                                              ],
                                              child: Text(
                                                  AppLocalizations.of(context)!.importance,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 16,
                                                      color: todoColors.labelPrimary
                                                  )
                                              )
                                          ),
                                          vertical4,
                                          Text(
                                              state.importance,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: todoColors.labelTertiary
                                              )
                                          )
                                        ]
                                    ),
                                    vertical16,
                                    const Divider(height: 0.5),
                                    vertical265,
                                    Row(
                                        children: [
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    AppLocalizations.of(context)!.makeItTo,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 16,
                                                        color: todoColors.labelPrimary
                                                    )
                                                ),
                                                vertical4,
                                                SizeTransition(
                                                    sizeFactor: animationController!.view,
                                                    child: Text(
                                                        state.dateTime == null
                                                            ? ""
                                                            : DateFormat.yMMMMd(locale?.languageCode).format(state.dateTime!),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14,
                                                            color: todoColors.colorBlue
                                                        )
                                                    )
                                                )
                                              ]
                                          ),
                                          const Spacer(),
                                          Switch(
                                              onChanged: (value) => onSwitchChanged(value),
                                              value: state.makeItTo
                                          )
                                        ]
                                    )
                                  ]
                              )
                          ),
                          const Divider(height: 0.5),
                          vertical22,
                          Row(
                              children: [
                                horizontal16,
                                Icon(
                                    Icons.delete,
                                    color: state.canDelete
                                        ? todoColors.colorRed
                                        : todoColors.labelDisable
                                ),
                                horizontal1702,
                                GestureDetector(
                                    onTap: () => delete(widget.todoModel),
                                    child: Text(
                                        AppLocalizations.of(context)!.delete,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: state.canDelete
                                                ? todoColors.colorRed
                                                : todoColors.labelDisable
                                        )
                                    )
                                ),
                                horizontal16
                              ]
                          )
                        ]
                    )
                )
            )
        )
    );
  }
}