library weekday_selector_formfield;

import 'package:flutter/material.dart';

class WeekDaySelectorFormField extends StatefulWidget {
  const WeekDaySelectorFormField(
      {Key key,
      this.autovalidate = false,
      this.enabled = true,
      this.onChange,
      this.onSaved,
      this.validator,
      this.displayDays = const [
        days.monday,
        days.tuesday,
        days.wednesday,
        days.thursday,
        days.friday,
        days.saturday,
        days.sunday
      ],
      this.language = lang.en,
      this.selectedFillColor,
      this.fillColor,
      this.highlightColor,
      this.splashColor,
      this.borderSide = const BorderSide(color: Colors.black, width: 1),
      this.initialValue,
      this.textStyle = const TextStyle(color: Colors.black),
      this.errorTextStyle = const TextStyle(color: Colors.red),
      this.axis = Axis.horizontal,
      this.crossAxisAlignment = WrapCrossAlignment.center,
      this.alignment = WrapAlignment.start,
      this.borderRadius = 8,
      this.elevation = 4.0,
      this.spacing = 5,
      this.runSpacing = 5,
      this.dayLong = 3,
      this.singleDay = false,
      this.boxConstraints =
          const BoxConstraints(minWidth: 40, minHeight: 40, maxWidth: 40, maxHeight: 40)})
      : super(key: key);

  final List<days> initialValue;
  final void Function(List<days>) onChange;
  final void Function(List<days>) onSaved;
  final String Function(List<days>) validator;
  final List<days> displayDays;
  final lang language;
  final Color fillColor;
  final Color selectedFillColor;
  final Color highlightColor;
  final Color splashColor;
  final BorderSide borderSide;
  final TextStyle textStyle;
  final TextStyle errorTextStyle;
  final WrapCrossAlignment crossAxisAlignment;
  final Axis axis;
  final bool autovalidate;
  final bool enabled;
  final double borderRadius;
  final double elevation;
  final double runSpacing;
  final double spacing;
  final WrapAlignment alignment;
  final int dayLong;
  final bool singleDay;
  final BoxConstraints boxConstraints;

  static const workDays = [days.monday, days.tuesday, days.wednesday, days.thursday, days.friday];

  static const weekendDays = [
    days.saturday,
    days.sunday,
  ];

  @override
  _WeekDaySelectorFormFieldState createState() => _WeekDaySelectorFormFieldState();
}

class _WeekDaySelectorFormFieldState extends State<WeekDaySelectorFormField> {
  List<Widget> displayedDays = [];
  List<days> daysSelected = [];

  @override
  void initState() {
    super.initState();
    if (this.widget.initialValue != null) daysSelected = this.widget.initialValue;

    // create all DisplayDays
    this.widget.displayDays.forEach((day) {
      displayedDays.add(_DayItem(
        borderSide: this.widget.borderSide,
        onTap: _dayTap,
        label: languages[day.index][widget.language],
        value: day,
        fillColor: widget.fillColor,
        selectedFillColor: this.widget.selectedFillColor,
        textStyle: this.widget.textStyle,
        highlightColor: this.widget.highlightColor,
        splashColor: this.widget.splashColor,
        borderRadius: this.widget.borderRadius,
        elevation: this.widget.elevation,
        dayLong: this.widget.dayLong,
        boxConstraints: widget.boxConstraints,
        selected: widget.initialValue == null
            ? false
            : widget.initialValue.firstWhere((d) => day == d, orElse: () => null) == null
                ? false
                : true,
      ));
    });
  }

  _dayTap(days day) {
    if (this.widget.singleDay) {
      if (!daysSelected.contains(day)) {
        daysSelected.clear();
        daysSelected.add(day);
      } else {
        daysSelected.remove(day);
      }
      if (widget.onChange != null) {
        widget.onChange(daysSelected);
      }
      setState(() {
        this.displayedDays.clear();
        this.widget.displayDays.forEach((day) {
          displayedDays.add(_DayItem(
            borderSide: this.widget.borderSide,
            onTap: _dayTap,
            label: languages[day.index][widget.language],
            value: day,
            fillColor: widget.fillColor,
            selectedFillColor: this.widget.selectedFillColor,
            textStyle: this.widget.textStyle,
            highlightColor: this.widget.highlightColor,
            splashColor: this.widget.splashColor,
            borderRadius: this.widget.borderRadius,
            elevation: this.widget.elevation,
            dayLong: this.widget.dayLong,
            boxConstraints: widget.boxConstraints,
            selected: daysSelected.contains(day),
          ));
        });
      });
    } else {
      if (daysSelected.contains(day)) {
        daysSelected.remove(day);
      } else {
        daysSelected.add(day);
      }
      if (widget.onChange != null) {
        widget.onChange(daysSelected);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<days>>(
      enabled: this.widget.enabled,
      initialValue: widget.initialValue,
      autovalidate: widget.autovalidate,
      onSaved: (days) {
        print("SELECTOR SAVE: " + daysSelected.toString());
        if (widget.onSaved != null) widget.onSaved(daysSelected);
      },
      validator: (days) {
        print("SELECTOR VALIDATOR: " + daysSelected.toString());
        if (widget.validator != null) return widget.validator(daysSelected);
        return null;
      },
      builder: (state) {
        return Column(
          textDirection: (this.widget.language == lang.ar) ? TextDirection.rtl : TextDirection.ltr,
          children: <Widget>[
            Container(
              child: Wrap(
                textDirection:
                    (this.widget.language == lang.ar) ? TextDirection.rtl : TextDirection.ltr,
                children: displayedDays,
                alignment: widget.alignment,
                direction: widget.axis,
                crossAxisAlignment: widget.crossAxisAlignment,
                spacing: widget.spacing,
                runSpacing: widget.runSpacing,
              ),
            ),
            state.hasError ? Text(state.errorText, style: this.widget.errorTextStyle) : Container()
          ],
        );
      },
    );
  }
}

class _DayItem extends StatefulWidget {
  _DayItem(
      {Key key,
      this.fillColor,
      this.selectedFillColor = Colors.red,
      this.label,
      this.onTap,
      this.value,
      this.textStyle,
      this.borderSide,
      this.highlightColor,
      this.splashColor,
      this.selected,
      this.borderRadius,
      this.elevation,
      this.dayLong,
      this.boxConstraints})
      : super(key: key);
  final bool selected;
  final Color fillColor;
  final Color selectedFillColor;
  final Function(days) onTap;
  final String label;
  final days value;
  final TextStyle textStyle;
  final BorderSide borderSide;
  final Color splashColor;
  final Color highlightColor;
  final double borderRadius;
  final double elevation;
  final int dayLong;
  final BoxConstraints boxConstraints;

  __DayItemState createState() => __DayItemState();
}

class __DayItemState extends State<_DayItem> {
  bool selected;

  @override
  Widget build(BuildContext context) {
    selected = this.widget.selected;
    final ButtonThemeData buttonTheme = ButtonTheme.of(context);
    //print(selected);
    return Container(
      constraints: this.widget.boxConstraints,
      child: RawMaterialButton(
          onPressed: () {
            if (widget.onTap != null) {
              widget.onTap(widget.value);
            }
            /*setState(() {
              selected = !selected;
            });*/
          },
          focusColor: widget.selectedFillColor,
          highlightColor: Colors.yellow,
          splashColor: this.widget.splashColor,
          elevation: this.widget.elevation,
          fillColor: selected == true
              ? widget.selectedFillColor ?? buttonTheme.colorScheme.background
              : widget.fillColor ?? buttonTheme.colorScheme.background,
          textStyle: widget.textStyle ?? Theme.of(context).textTheme.button,
          //if not textstyle sended, textTheme.button by default
          child: Container(
              alignment: Alignment.center,
              child: Text(widget.dayLong == null || widget.dayLong == 0
                  ? widget.label.substring(0, 2)
                  : widget.dayLong < widget.label.length
                      ? widget.label.substring(0, widget.dayLong)
                      : widget.label)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              side: selected ? widget.borderSide : BorderSide.none)),
    );
  }
}

enum days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }
enum lang { en, es, pt, ar }

const languages = [
  {lang.en: 'Monday', lang.es: 'Lunes', lang.pt: 'Segunda', lang.ar: 'اثنين'}, // monday
  {lang.en: 'Tuesday', lang.es: 'Martes', lang.pt: 'Terça', lang.ar: 'ثلاثاء'}, // tuesday
  {lang.en: 'Wednesday ', lang.es: 'Miercoles', lang.pt: 'Quarta', lang.ar: 'اربع'}, // wednesday
  {lang.en: 'Thursday', lang.es: 'Jueves', lang.pt: 'Quinta', lang.ar: 'خميس'}, // thursday
  {lang.en: 'Friday', lang.es: 'Viernes', lang.pt: 'Sexta', lang.ar: 'جمعة'}, // friday
  {lang.en: 'Saturday', lang.es: 'Sabado', lang.pt: 'Sabado', lang.ar: 'سبت'}, // thursday
  {lang.en: 'Sunday', lang.es: 'Domingo', lang.pt: 'Domingo', lang.ar: 'احد'} // saturday
];
