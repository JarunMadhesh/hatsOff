import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hatsoff/screens/task/addTask.dart';
import '../screens/habits/addHabitScreen.dart';

class Plus extends StatelessWidget {
  final bool _isbig;
  final String purpose;

  Plus(this._isbig, this.purpose);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if(purpose=='habit') {
          Navigator.of(context).pushNamed(AddHabit.route);
        } else {
          Navigator.of(context).pushNamed(AddTask.route);
        }
        
      },
      child: Center(
        child: Container(
          width: _isbig? MediaQuery.of(context).size.height * 0.272 :MediaQuery.of(context).size.height * 0.198,
          height: _isbig? MediaQuery.of(context).size.height * 0.272 :MediaQuery.of(context).size.height * 0.198,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xffffffff),
            border: Border.all(
              width: 1,
              color: const Color(0xffebebeb),
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.height * 0.176)),
            boxShadow: [
              BoxShadow(
                offset: const Offset(6, 6),
                blurRadius: 6,
                color: const Color(0xff9f9f9f).withOpacity(0.41),
              )
            ],
          ),
          child: Transform.scale(
            scale: _isbig? 1.4: 1,
                    child: SvgPicture.asset(
              'assets/icons/plusIcon.svg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
