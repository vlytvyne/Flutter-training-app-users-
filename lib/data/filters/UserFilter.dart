class UserFilter {

	bool _showMen = true;
	bool _showWomen = true;
	bool ascendingOrder = false;

	bool get showMen => _showMen;

	set showMen(bool value) {
		if (!_showWomen && !value) {
			_showMen = false;
			_showWomen = true;
		} else {
			_showMen = value;
		}
	}

	bool get showWomen => _showWomen;

	set showWomen(bool value) {
		if (!_showMen && !value) {
			_showWomen = false;
			_showMen = true;
		} else {
			_showWomen = value;
		}
	}

	bool get showBothGenders => _showWomen && _showMen;

	UserFilter(this._showMen, this._showWomen, this.ascendingOrder);

	UserFilter clone() => UserFilter(_showMen, _showWomen, ascendingOrder);

}