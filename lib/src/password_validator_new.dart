import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PasswordValidator extends StatefulWidget {
  final int minLength;
  final int maxLength;
  final bool shouldHaveUppercase;
  final bool shouldHaveLowercase;
  final bool shouldHaveSpecialChar;
  final bool shouldHaveADigit;
  final Function(bool) onValidationCallback;
  final Function(String) validatedPassword;


  const PasswordValidator(
      {required this.minLength,
        required this.maxLength,
        required this.shouldHaveUppercase,
        required this.shouldHaveLowercase,
        required this.shouldHaveSpecialChar,
        required this.shouldHaveADigit,
        required this.onValidationCallback,
        required this.validatedPassword,
        Key? key})
      : super(key: key);

  @override
  State<PasswordValidator> createState() => _PasswordValidatorState();
}

class _PasswordValidatorState extends State<PasswordValidator> {
  double progress = 0;
  double totalProgress=100;
  bool charSize = false;
  bool upperCaseFlag = false;
  bool lowerCaseFlag = false;
  bool numberFlag = false;
  bool specialCharFlag = false;
  bool letterFlag = false;
  bool _isPasswordVisible = false;

  final TextEditingController controller= TextEditingController();

  @override
  void initState() {
    if(widget.shouldHaveUppercase){
      totalProgress+=100;
    }
    if(widget.shouldHaveLowercase){
      totalProgress+=100;
    }
    if(widget.shouldHaveSpecialChar){
      totalProgress+=100;
    }
    if(widget.shouldHaveADigit){
      totalProgress+=100;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: controller,
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueAccent),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusColor: Colors.blue,
                labelText: "Password",
                labelStyle:
                const TextStyle(fontSize: 12, color: Colors.blueAccent),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 1.4)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 1.4)),
                errorStyle: const TextStyle(color: Colors.red, height: 1),
                enabled: true,
                suffixIcon: IconButton(
                  icon: _isPasswordVisible == true
                      ? const Icon(Icons.visibility,
                      color: Colors.blueAccent, size: 25)
                      : const Icon(Icons.visibility_off,
                      color: Colors.blueAccent, size: 25),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              cursorColor: Colors.blueAccent,
              cursorHeight: 22,
              obscureText: _isPasswordVisible,
              onChanged: (String value) {
                updateProgress(value);
                if(progress/totalProgress==1){
                  widget.onValidationCallback(true);
                  widget.validatedPassword(controller.text);
                }
              },
            ),
            const SizedBox(height: 13),
            LinearPercentIndicator(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              backgroundColor: Colors.grey[300],
              progressColor: progress <= 200
                  ? Colors.red
                  : progress >= 201 && progress < 499
                  ? Colors.yellow
                  : Colors.green,
              percent: progress / totalProgress,
              barRadius: const Radius.circular(20),
              lineHeight: 7,
            ),
            const SizedBox(height: 35),
            Row(
              //spacing: 9,
              //direction: Axis.horizontal,
              //crossAxisAlignment: WrapCrossAlignment.start,
              //alignment: WrapAlignment.start,
              //runSpacing: 7,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _tickIcon(charSize ? Colors.green : Colors.grey),
                    const SizedBox(width: 2),
                    getText(
                        text: '8 to 32 characters',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _tickIcon(upperCaseFlag ? Colors.green : Colors.grey),
                    const SizedBox(width: 2),
                    getText(
                        text: '1 upper case',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _tickIcon(lowerCaseFlag ? Colors.green : Colors.grey),
                    const SizedBox(width: 2),
                    getText(
                        text: '1 lower case',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)
                  ],
                ),
              ],
            ),
            const SizedBox(height: 9),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _tickIcon(numberFlag ? Colors.green : Colors.grey),
                    const SizedBox(width: 2),
                    getText(
                        text: '1 number',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _tickIcon(specialCharFlag ? Colors.green : Colors.grey),
                    const SizedBox(width: 2),
                    getText(
                        text: '1 special character',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  _tickIcon(Color color) {
    return Icon(Icons.done, size: 17, color: color);
  }

  void updateProgress(String password) {
    print(password.hasDigit);
    print(numberFlag);

    if (widget.shouldHaveUppercase && password.containsUppercase && !upperCaseFlag) {
      setState(() {
        progress += 100;
        upperCaseFlag = true;
      });
    }
    if (widget.shouldHaveUppercase && !password.containsUppercase && progress > 0 && upperCaseFlag) {
      print('decreasing progress');
      setState(() {
        progress -= 100;
        upperCaseFlag = false;
      });
    }

    if (widget.shouldHaveLowercase && password.containsLowercase && !lowerCaseFlag) {
      setState(() {
        progress += 100;
        lowerCaseFlag = true;
      });
    }
    if (widget.shouldHaveLowercase && !password.containsLowercase && progress > 0 && lowerCaseFlag) {
      print('decreasing progress');
      setState(() {
        progress -= 100;
        lowerCaseFlag = false;
      });
    }


    if (widget.shouldHaveADigit &&password.hasDigit && !numberFlag) {
      print('here');
      setState(() {
        progress += 100;
        numberFlag = true;
      });
      print(progress);
    }
    if (widget.shouldHaveLowercase && !password.hasDigit && progress > 0 && numberFlag) {
      print('decreasing progress');
      print('here');
      setState(() {
        progress -= 100;
        numberFlag = false;
      });
      print(progress);
    }

    if (isLengthAllowed(password,widget.minLength,widget.maxLength) && !charSize) {
      setState(() {
        progress += 100;
        charSize = true;
      });
    }
    if (!isLengthAllowed(password,widget.minLength,widget.maxLength)  && progress > 0 && charSize) {
      print('decreasing progress');
      setState(() {
        progress -= 100;
        charSize = false;
      });
    }

    if (widget.shouldHaveSpecialChar && password.hasSpecialCharacter && !specialCharFlag) {
      setState(() {
        progress += 100;
        specialCharFlag = true;
      });
    }
    if (widget.shouldHaveSpecialChar &&  !password.hasSpecialCharacter && progress > 0 && specialCharFlag) {
      print('decreasing progress');
      setState(() {
        progress -= 100;
        specialCharFlag = false;
      });
    }

    print('updated progress: $progress');
  }
}

bool isLengthAllowed(String password, int min, int max){
  return password.contains(RegExp('^.{$min,$max}\$'));
}

extension Validator on String {
  bool get containsUppercase => contains(RegExp(r'[A-Z]'));

  bool get containsLowercase => contains(RegExp(r'[a-z]'));


  bool get hasDigit => contains(RegExp(r'\d'));

  bool get hasSpecialCharacter =>
      contains(RegExp(r'[!\"#$%&’()*+,-./ :;<=>?@[\]^_`{|~)]'));
}

Widget getText(
    {required String text,
      required double fontSize,
      required FontWeight fontWeight,
      required Color color}) {
  return Text(
    text,
    style: TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color),
  );
}
