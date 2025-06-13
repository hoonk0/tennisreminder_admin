library;

import 'package:flutter/material.dart';

class CustomNumberPagination extends StatelessWidget {
  final Function(int) onPageChanged;
  final int pageTotal;
  final int pageInit;
  final int threshold;
  final Widget iconToFirst;
  final Widget iconPrevious;
  final Widget iconNext;
  final Widget iconToLast;
  final double fontSize;
  final double buttonSpacing;
  final double groupSpacing;
  final bool hasFirstLast;

  /// Creates a NumberPagination
  const CustomNumberPagination({
    required this.onPageChanged,
    required this.pageTotal,
    this.threshold = 10,
    this.pageInit = 1,
    this.iconToFirst = const Icon(Icons.first_page),
    this.iconPrevious = const Icon(Icons.keyboard_arrow_left),
    this.iconNext = const Icon(Icons.keyboard_arrow_right),
    this.iconToLast = const Icon(Icons.last_page),
    this.fontSize = 15,
    this.buttonSpacing = 4,
    this.groupSpacing = 10,
    this.hasFirstLast = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pageService = NumberPageService(pageInit);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: _NumberPageContainer(
        pageService: pageService,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListenableBuilder(
              listenable: pageService,
              builder: (_, __) => Row(
                children: [
                  Builder(
                    builder: (context) {
                      if (hasFirstLast) {
                        return Row(
                          children: [
                            _ControlButton(
                              iconToFirst,
                              pageService.currentPage != 1,
                              (c) => _changePage(c, 1),
                            ),
                            SizedBox(width: buttonSpacing),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  _ControlButton(
                    iconPrevious,
                    pageService.currentPage != 1,
                    (c) => _changePage(c, pageService.currentPage - 1),
                  ),
                ],
              ),
            ),
            SizedBox(width: groupSpacing),
            Flexible(
              fit: FlexFit.loose,
              child: ListenableBuilder(
                listenable: pageService,
                builder: (context, child) {
                  final currentPage = pageService.currentPage;

                  final rangeStart =
                      currentPage % threshold == 0 ? currentPage - threshold : (currentPage ~/ threshold) * threshold;

                  final rangeEnd = rangeStart + threshold > pageTotal ? pageTotal : rangeStart + threshold;

                  return Row(mainAxisSize: MainAxisSize.min, children: [
                    for (var i = rangeStart; i < rangeEnd; i++)
                      _NumberButton(
                        i + 1,
                        fontSize,
                        (c, number) {
                          _changePage(c, number);
                        },
                      )
                  ]);
                },
              ),
            ),
            SizedBox(width: groupSpacing),
            ListenableBuilder(
              listenable: pageService,
              builder: (_, __) => Row(
                children: [
                  _ControlButton(
                    iconNext,
                    pageService.currentPage != pageTotal,
                    (c) => _changePage(c, pageService.currentPage + 1),
                  ),
                  Builder(
                    builder: (context) {
                      if (hasFirstLast) {
                        return Row(
                          children: [
                            SizedBox(width: buttonSpacing),
                            _ControlButton(
                              iconToLast,
                              pageService.currentPage != pageTotal,
                              (c) => _changePage(c, pageTotal),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changePage(BuildContext context, targetPage) {
    int newPage = targetPage.clamp(1, pageTotal);

    if (_NumberPageContainer.of(context).currentPage != newPage) {
      _NumberPageContainer.of(context).currentPage = newPage;
      onPageChanged(newPage);
    }
  }
}

class _NumberPageContainer extends InheritedWidget {
  final NumberPageService pageService;

  const _NumberPageContainer({required this.pageService, required super.child});

  @override
  bool updateShouldNotify(covariant _NumberPageContainer oldWidget) {
    return oldWidget.pageService != pageService;
  }

  static NumberPageService of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_NumberPageContainer>()!.pageService;
  }
}

class _ControlButton extends StatelessWidget {
  final Widget icon;
  final bool enabled;
  final Function(BuildContext) onTap;

  const _ControlButton(
    this.icon,
    this.enabled,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => onTap(context) : null,
      child: Container(
        width: 32,
        height: 32,
        color: Colors.transparent,
        child: Center(child: icon),
      ),
    );
  }
}

class NumberPageService with ChangeNotifier {
  int _currentPage = -1;
  int _previousPage = -1;

  NumberPageService(this._currentPage);

  set currentPage(int n) {
    _previousPage = _currentPage;
    _currentPage = n;
    notifyListeners();
  }

  int get currentPage => _currentPage;

  int get previousPage => _previousPage;
}

class _NumberButton extends StatelessWidget {
  final int number;
  final double fontSize;
  final Function(BuildContext, int) onSelect;

  const _NumberButton(
    this.number,
    this.fontSize,
    this.onSelect,
  );

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: () {
          onSelect(context, number);
        },
        child: Container(
          width: 32,
          height: 32,
          color: Colors.transparent,
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: fontSize,
                color: number == _NumberPageContainer.of(context).currentPage ? Colors.black : const Color(0xFFAAAAAA),
                fontWeight: number == _NumberPageContainer.of(context).currentPage ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
