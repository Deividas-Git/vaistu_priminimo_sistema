import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class AddInformationWidget extends StatelessWidget {
  const AddInformationWidget({
    super.key,
    required this.label,
    required this.onStartAddingInfo,
  });
  final String label;
  final VoidCallback onStartAddingInfo;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onStartAddingInfo,
        splashColor: ColorScheme.of(context).primary.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(5),
        highlightColor: ColorScheme.of(
          context,
        ).secondary.withValues(alpha: 0.35),
        child: Ink(
          child: ThemedContainerWidget(
            child: Row(
              children: [
                SizedBox(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: BoxBorder.all(
                        color: ColorScheme.of(
                          context,
                        ).primary, //const Color.fromARGB(255, 11, 138, 15),
                        width: 2,
                      ),
                      color: ColorScheme.of(
                        context,
                      ).primary, //const Color.fromARGB(255, 9, 175, 14),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorScheme.of(context).primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
