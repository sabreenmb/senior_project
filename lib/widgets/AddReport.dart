import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:senior_project/interface/AddLostItemScreen.dart';
import 'package:senior_project/interface/ServicesScreen.dart';
import 'package:senior_project/widgets/LostCard.dart';
import 'package:senior_project/theme.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';
import '../model/lost_item_report.dart';

class FloatAddingButton extends StatefulWidget {
  @override
  _FloatAddingButtonState createState() => _FloatAddingButtonState();
}

class _FloatAddingButtonState extends State<FloatAddingButton>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  static const double _expandedSize = 200.0;
  static const double _collapsedSize = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 201, 54, 54),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.lightBlue,
        hoverElevation: 10,
        splashColor: Colors.grey,
        tooltip: 'create',
        elevation: 4,
        onPressed: _toggleExpanded,
        child: _isExpanded ? Icon(Icons.close) : Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // Add the expanded options as a child of the Stack widget
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            //top: ,
            bottom: size.height * 0.06,

            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: _isExpanded ? _expandedSize : _collapsedSize,
              height: _isExpanded ? _expandedSize : _collapsedSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    _isExpanded ? _expandedSize : _collapsedSize),
                child: Material(
                  elevation: _isExpanded ? 6.0 : 0.0,
                  //color: ,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isExpanded) ...[
                        _buildOption('إنشاء إعلان موجود', () {
                          // Handle add item action
                        }),
                        SizedBox(height: 16.0),
                        _buildOption('إنشاء إعلان مفقود', () {
                          // Handle edit item action
                        }),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String label, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: FloatingActionButton.extended(
        // fixedSize: const Size(175, 50),
        backgroundColor: CustomColors.lightBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
        //focusColor: CustomColors.lightBlue,
        onPressed: onPressed,
        label: Text(label, style: TextStyles.text3),
      ),
    );
  }
}
