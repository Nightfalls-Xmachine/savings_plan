import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:saving/models/models.dart';
import 'package:saving/screens/saving_tile.dart';

class SavingItemScreen extends StatefulWidget {
  //TODO: onCreate is a callback that lets you know when a new item is created
  final Function(SavingItem) onCreate;
  //TODO: onUpdate is a callback that returns the updated saving item
  final Function(SavingItem) onUpdate;
  //TODO: The saving item that the user created
  final SavingItem? originalItem;
  //TODO: isUpdating determines whether the user is creating or editing an item
  final bool isUpdating;

  const SavingItemScreen({
    Key? key,
    required this.onCreate,
    required this.onUpdate,
    this.originalItem,
    // isUpdating is true when originalItem is not equal to null
  }) : isUpdating = (originalItem != null), super(key: key);

  @override
  State<SavingItemScreen> createState() => _SavingItemScreenState();
}

class _SavingItemScreenState extends State<SavingItemScreen> {
  //TODO: Add grocery item screen state properties
  final _nameController = TextEditingController();
  String _name = '';
  Importance _importance = Importance.low;
  DateTime _dueDate = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  Color _currentColor = Colors.green;
  int _currentSliderValue = 0;

  //TODO: Add initstate()
  @override
  void initState(){
    final originalItem = widget.originalItem;
    if(originalItem != null){
      _nameController.text = originalItem.name;
      _name = originalItem.name;
      _currentSliderValue = originalItem.quantity;
      _importance = originalItem.importance;
      _currentColor = originalItem.color;
      final date = originalItem.date;
      _timeOfDay = TimeOfDay(hour: date.hour, minute: date.minute);
      _dueDate = date;
    }
    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });
    super.initState();
  }

  //TODO: Add dispose()
  void dispose(){
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Add SavingItemScreen Scaffold
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (){
                //TODO: Add callback handler
                final savingItem = SavingItem(
                  id: widget.originalItem?.id ?? const Uuid().v1(),
                  name: _nameController.text,
                  importance: _importance,
                  color: _currentColor,
                  quantity: _currentSliderValue,
                  date: DateTime(
                    _dueDate.year,
                    _dueDate.month,
                    _dueDate.day,
                    _timeOfDay.hour,
                    _timeOfDay.minute,
                  ),
                );

                if (widget.isUpdating) {
                  // 2
                  widget.onUpdate(savingItem);
                } else {
                  // 3
                  widget.onCreate(savingItem);
                }
              },
              icon: const Icon(Icons.check),
          )
        ],
        elevation: 0.0,
        title: Text(
          'Saving Plan',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            //TODO: Add name TextField
            buildNameField(),
            //TODO: Add Importance selection
            buildImportanceField(),
            //TODO: Add date picker
            buildDateField(context),
            //TODO: Add time picker
            buildTimeField(context),
            //TODO: Add color picker
            buildColorPicker(context),
            //TODO: Add slider
            buildQuantityField(),
            //TODO: Add Grocery Tile
            SavingTile(
              item: SavingItem(
                id: 'previewMode',
                name: _name,
                importance: _importance,
                color: _currentColor,
                quantity: _currentSliderValue,
                date: DateTime(
                  _dueDate.year,
                  _dueDate.month,
                  _dueDate.day,
                  _timeOfDay.hour,
                  _timeOfDay.minute,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//TODO: Add buildNameField()
  Widget buildNameField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item Name',
          style: GoogleFonts.lato(fontSize: 28.0),
        ),
        TextField(
          controller: _nameController,
          cursorColor: _currentColor,
          decoration: InputDecoration(
            hintText: 'E.g. Apples, Banana, 1 Bag of salt',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
          ),
        )
      ],
    );
  }
//TODO: Add buildImportanceField()
  Widget buildImportanceField() {
    // 1
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2
        Text(
          'Importance',
          style: GoogleFonts.lato(fontSize: 28.0),
        ),
        // 3
        Wrap(
          spacing: 10.0,
          children: [
            // 4
            ChoiceChip(
              // 5
              selectedColor: Colors.black,
              // 6
              selected: _importance == Importance.low,
              label: const Text(
                'low',
                style: TextStyle(color: Colors.white),
              ),
              // 7
              onSelected: (selected) {
                setState(() => _importance = Importance.low);
              },
            ),
            ChoiceChip(
              selectedColor: Colors.black,
              selected: _importance == Importance.medium,
              label: const Text(
                'medium',
                style: TextStyle(color: Colors.white),
              ),
              onSelected: (selected) {
                setState(() => _importance = Importance.medium);
              },
            ),
            ChoiceChip(
              selectedColor: Colors.black,
              selected: _importance == Importance.high,
              label: const Text(
                'high',
                style: TextStyle(color: Colors.white),
              ),
              onSelected: (selected) {
                setState(() => _importance = Importance.high);
              },
            ),
          ],
        )
      ],
    );
  }
//TODO: Add buildDateField()
  Widget buildDateField(BuildContext context) {
    // 1
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2
        Row(
          // 3
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 4
            Text(
              'Date',
              style: GoogleFonts.lato(fontSize: 28.0),
            ),
            // 5
            TextButton(
              child: const Text('Select'),
              // 6
              onPressed: () async {
                final currentDate = DateTime.now();
                // 7
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: currentDate,
                  firstDate: currentDate,
                  lastDate: DateTime(currentDate.year + 5),
                );

                // 8
                setState(
                      () {
                    if (selectedDate != null) {
                      _dueDate = selectedDate;
                    }
                  },
                );
              },
            ),
          ],
        ),
        // 9
        Text('${DateFormat('yyyy-MM-dd').format(_dueDate)}'),
      ],
    );
  }
//TODO: Add buildTimeField()
  Widget buildTimeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time of Day',
              style: GoogleFonts.lato(fontSize: 28.0),
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () async {
                // 1
                final timeOfDay = await showTimePicker(
                  // 2
                  initialTime: TimeOfDay.now(),
                  context: context,
                );

                // 3
                setState(() {
                  if (timeOfDay != null) {
                    _timeOfDay = timeOfDay;
                  }
                });
              },
            ),
          ],
        ),
        Text('${_timeOfDay.format(context)}'),
      ],
    );
  }
//TODO: Add buildColorPicker()
  Widget buildColorPicker(BuildContext context) {
    // 1
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 2
        Row(
          children: [
            Container(
              height: 50,
              width: 10,
              color: _currentColor,
            ),
            const SizedBox(width: 8),
            Text('Color', style: GoogleFonts.lato(fontSize: 28)),
          ],
        ),
        // 3
        TextButton(
          child: const Text('Select'),
          onPressed: () {
            // 4
            showDialog(
              context: context,
              builder: (context) {
                // 5
                return AlertDialog(
                  content: BlockPicker(
                      pickerColor: Colors.white,
                      // 6
                      onColorChanged: (color) {
                        setState(() => _currentColor = color);
                      }),
                  actions: [
                    // 7
                    TextButton(
                      child: const Text('Save'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
//TODO: Add buildQuantityField()
  Widget buildQuantityField() {
    // 1
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Quantity',
              style: GoogleFonts.lato(fontSize: 28.0),
            ),
            const SizedBox(width: 16.0),
            Text(
              _currentSliderValue.toInt().toString(),
              style: GoogleFonts.lato(fontSize: 18.0),
            ),
          ],
        ),
        // 3
        Slider(
          // 4
          inactiveColor: _currentColor.withOpacity(0.5),
          activeColor: _currentColor,
          // 5
          value: _currentSliderValue.toDouble(),
          // 6
          min: 0.0,
          max: 100.0,
          // 7
          divisions: 100,
          // 8
          label: _currentSliderValue.toInt().toString(),
          // 9
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value.toInt();
            });
          },
        ),
      ],
    );
  }
//TODO: Add Grocery Tile
}
