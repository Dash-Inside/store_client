import 'package:flutter/material.dart';
import 'package:store_client/src/presentation/widgets/filled_button_widget.dart';
import 'package:store_client/src/presentation/widgets/text_field_widget.dart';

class RestorePage extends StatelessWidget {
  static const double sizedboxHeight = 8.0;
  static const double edgeInsetsContainer = 16.0;
  static const double fontSizeHeaders = 28.0;
  static const int flex = 2;
  RestorePage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color colorSurface = colorScheme.surface;
    Color colorSecondary = colorScheme.secondary;

    return Scaffold(
      backgroundColor: colorSurface,
      appBar: AppBar(
        backgroundColor: colorSurface,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: colorSecondary,
          ),
        ),
        title: Text('Restore'),
        titleTextStyle: TextStyle(
          height: 1.0,
          color: colorSecondary,
          fontSize: fontSizeHeaders,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(edgeInsetsContainer),
        child: Column(
          children: [
            Spacer(),
            Column(
              children: [
                TextFieldWidget(text: 'Restore code'),
                SizedBox(height: sizedboxHeight),
                TextFieldWidget(text: 'New password'),
                SizedBox(height: sizedboxHeight),
                TextFieldWidget(text: 'New password'),
              ],
            ),
            Spacer(flex: flex),
            FilledButtonWidget(hintText: 'Restore'),
          ],
        ),
      ),
    );
  }
}
