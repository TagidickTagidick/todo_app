import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../models/todo/todo_model.dart';
import '../../../utils/constants/todo_colors.dart';
import '../../bloc/todo_bloc.dart';

class MyTodoListTile extends StatefulWidget {
  const MyTodoListTile({
    Key? key,
    required this.todoModel,
    required this.handleItemTapped
  }) : super(key: key);

  final TodoModel todoModel;
  final Function(TodoModel?) handleItemTapped;

  @override
  MyTodoListTileState createState() => MyTodoListTileState();
}

class MyTodoListTileState extends State<MyTodoListTile>
with SingleTickerProviderStateMixin {
  AnimationController? _slideAnimationController;
  Animation<double>? _heightFactorAnimation;

  @override
  void initState() {
    super.initState();
    _slideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _heightFactorAnimation = CurvedAnimation(
        parent: _slideAnimationController!.drive(
          Tween<double>(
            begin: 1.0,
            end: 0.0,
          ),
        ),
        curve: Curves.ease
    );
  }

  @override
  void dispose() {
    super.dispose();
    _slideAnimationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TodoColors todoColors = Theme.of(context).extension<TodoColors>()!;
    return AnimatedBuilder(
        animation: _slideAnimationController!,
        builder: (BuildContext context, Widget? child) => ClipRect(
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: _heightFactorAnimation?.value,
            child: child
          )
        ),
      child: Slidable(
          startActionPane: ActionPane(
              extentRatio: 0.2,
              motion: const ScrollMotion(),
              dragDismissible: true,
              children: [
                SlidableAction(
                    onPressed: (context) {
                      if (!widget.todoModel.done) {
                        context.read<TodoBloc>().add(ToggleTodo(
                            id: widget.todoModel.id,
                            value: true
                        ));
                      }
                    },
                    backgroundColor: todoColors.colorGreen!,
                    foregroundColor: Colors.white,
                    icon: Icons.check
                )
              ]
          ),
          endActionPane: ActionPane(
              extentRatio: 0.2,
              motion: const ScrollMotion(),
              dragDismissible: true,
              children: [
                SlidableAction(
                    onPressed: (slidableContext) => context.read<TodoBloc>().add(DeleteTodo(id: widget.todoModel.id)),
                    backgroundColor: todoColors.colorRed!,
                    foregroundColor: Colors.white,
                    icon: Icons.delete
                )
              ]
          ),
          child: ListTile(
              leading: Checkbox(
                  onChanged: (_) => context.read<TodoBloc>().add(ToggleTodo(
                    id: widget.todoModel.id,
                    value: !widget.todoModel.done
                  )),
                  value: widget.todoModel.done,
                  fillColor: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> states) =>
                      widget.todoModel.importance == "important"
                          ? todoColors.remoteColor
                          : widget.todoModel.done
                          ? todoColors.colorGreen
                          : todoColors.supportSeparator
                  )
              ),
              title: widget.todoModel.deadline == null
                  ? widget.todoModel.importance == "low"
                  ? Text(
                  widget.todoModel.text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      decoration: widget.todoModel.done
                          ? TextDecoration.lineThrough
                          : null,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: widget.todoModel.done
                          ? todoColors.labelTertiary
                          : todoColors.labelPrimary
                  )
              )
                  : RichText(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      children: [
                        widget.todoModel.importance == "basic"
                            ? const TextSpan(
                            text: "↓ ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: Color(0xff8E8E93)
                            )
                        ) : TextSpan(
                            text: "!! ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: todoColors.remoteColor
                            )
                        ),
                        TextSpan(
                            text: widget.todoModel.text,
                            style: TextStyle(
                                decoration: widget.todoModel.done
                                    ? TextDecoration.lineThrough
                                    : null,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: widget.todoModel.done
                                    ? todoColors.labelTertiary
                                    : todoColors.labelPrimary
                            )
                        )
                      ]
                  )
              )
                  : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.todoModel.importance == "low"
                        ? Text(
                        widget.todoModel.text,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            decoration: widget.todoModel.done
                                ? TextDecoration.lineThrough
                                : null,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: widget.todoModel.done
                                ? todoColors.labelTertiary
                                : todoColors.labelPrimary
                        )
                    )
                        : RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            children: [
                              widget.todoModel.importance == "basic"
                                  ? const TextSpan(
                                  text: "↓ ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                      color: Color(0xff8E8E93)
                                  )
                              ) : TextSpan(
                                  text: "!! ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                      color: todoColors.remoteColor
                                  )
                              ),
                              TextSpan(
                                  text: widget.todoModel.text,
                                  style: TextStyle(
                                      decoration: widget.todoModel.done
                                          ? TextDecoration.lineThrough
                                          : null,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: widget.todoModel.done
                                          ? todoColors.labelTertiary
                                          : todoColors.labelPrimary
                                  )
                              )
                            ]
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                            "дата",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: todoColors.labelTertiary
                            )
                        )
                    )
                  ]
              ),
              trailing: GestureDetector(
                  onTap: () => widget.handleItemTapped(widget.todoModel),
                  child: Icon(
                      Icons.info_outline,
                      color: todoColors.labelTertiary
                  )
              )
          )
      )
    );
  }
}