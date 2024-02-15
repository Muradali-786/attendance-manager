import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

class StepperPrac extends StatefulWidget {
  const StepperPrac({super.key});

  @override
  State<StepperPrac> createState() => _StepperPracState();
}

class _StepperPracState extends State<StepperPrac> {
  int activeStep = 2;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 60),
            EasyStepper(
              activeStep: activeStep,
              stepShape: StepShape.circle,
              alignment: Alignment.center,
              lineStyle: LineStyle(
                lineType: LineType.normal,
                lineLength: w * 0.38,
                defaultLineColor: activeStep == 0 || activeStep == 2
                    ? Colors.grey
                    : Colors.green,
                lineThickness: 2,
              ),
              borderThickness: 8,

              stepRadius: 11,
              activeStepBackgroundColor: Colors.white,
              activeStepBorderColor: Colors.grey,
              finishedStepBorderColor:
              activeStep == 1 ? Colors.green : Colors.grey,
              finishedStepBackgroundColor:
              activeStep == 1 ? Colors.green : Colors.white,
              defaultStepBorderType: BorderType.normal,
              showLoadingAnimation: false,
              steps: [
                _classStep(),
                _studentsStep(),
              ],
              onStepReached: (index) => setState(() => activeStep = index),
            ),
          ],
        ),
      ),
    );
  }

  EasyStep _classStep() {
    return EasyStep(
      customStep: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Opacity(
          opacity: activeStep >= 0 ? 1 : 0.3,
          child: activeStep == 0 || activeStep == 2
              ? Container(
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
          )
              : const Icon(
            Icons.check,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
      customTitle: const Text(
        'Class',
        textAlign: TextAlign.center,
        style: TextStyle(height: 1.4,fontSize: 12),
      ),
    );
  }

  EasyStep _studentsStep() {
    return EasyStep(
      customStep: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: activeStep == 1
            ? Container(
          height: 8,
          width: 8,
          decoration: const BoxDecoration(
              color: Colors.green, shape: BoxShape.circle),
        )
            : null,
      ),
      customTitle: const Text(
        'Students',
        textAlign: TextAlign.center,
        style: TextStyle(height: 1.4,fontSize: 12),

      ),
    );
  }
}
