/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Overhype Studios | 2013 - 2020
 * 
 *  @Author:		Overhype Studios
 *  @Date:			12.04.2017 (refactored: 03.10.2017)
 *  @Description:	Options Menu Module - Controls Panel JS
 */
"use strict";


var OptionsMenuModuleControlsPanel = function(_dataSource)
{
	this.mDataSource = _dataSource;
 
	// container
	this.mContainer = null;
	
	// controls
	this.mEdgeOfScreenCheckbox  = null;
	this.mDragWithMouseCheckbox = null;
	this.mHardwareMouseCheckbox = null;

	this.mEdgeOfScreenLabel		= null;
	this.mDragWithMouseLabel	= null;
	this.mHardwareMouseLabel	= null;

    this.registerDatasourceListener();
};


OptionsMenuModuleControlsPanel.prototype.createDIV = function (_parentDiv)
{
	// create: character panel (init hidden!)
	this.mContainer = $('<div class="controls-panel display-none"></div>');
    _parentDiv.append(this.mContainer);

	// create: columns
	var leftColumn = $('<div class="column"></div>');
	this.mContainer.append(leftColumn);
	var rightColumn = $('<div class="column"></div>');
	this.mContainer.append(rightColumn);

	// create: camera options
	var row = $('<div class="row"></div>');
	leftColumn.append(row);
	var tile = $('<div class="title title-font-big font-color-title">Scrollmode</div>');
	row.append(tile);

	var dragWithMouseControl = $('<div class="control"></div>');
	row.append(dragWithMouseControl);
	this.mDragWithMouseCheckbox = $('<input type="radio" id="cb-drag-with-mouse" name="scrollmode" />');
	dragWithMouseControl.append(this.mDragWithMouseCheckbox);
	var dragWithMouseCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-drag-with-mouse">Drag with Mouse</label>');
	this.mDragWithMouseLabel = dragWithMouseCheckboxLabel;
	dragWithMouseControl.append(dragWithMouseCheckboxLabel);
	this.mDragWithMouseCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	var edgeOfScreenControl = $('<div class="control"></div>');
	row.append(edgeOfScreenControl);
	this.mEdgeOfScreenCheckbox = $('<input type="radio" id="cb-edge-of-screen" name="scrollmode" />');
	edgeOfScreenControl.append(this.mEdgeOfScreenCheckbox);
	var edgeOfScreenCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-edge-of-screen">Edge of Screen</label>');
	this.mEdgeOfScreenLabel = edgeOfScreenCheckboxLabel;
	edgeOfScreenControl.append(edgeOfScreenCheckboxLabel);
	this.mEdgeOfScreenCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	// create: mouse options
	row = $('<div class="row"></div>');
	rightColumn.append(row);
	tile = $('<div class="title title-font-big font-color-title">Mouse</div>');
	row.append(tile);
	
	var hardwareMouseControl = $('<div class="control"></div>');
	row.append(hardwareMouseControl);
	this.mHardwareMouseCheckbox = $('<input type="checkbox" id="cb-hardware-mouse" name="hardware-mouse" />');
	hardwareMouseControl.append(this.mHardwareMouseCheckbox);
	var hardwareMouseCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-hardware-mouse">Hardware Cursor</label>');
	this.mHardwareMouseLabel = hardwareMouseCheckboxLabel;
	hardwareMouseControl.append(hardwareMouseCheckboxLabel);
	this.mHardwareMouseCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

    this.setupEventHandler();
};

OptionsMenuModuleControlsPanel.prototype.destroyDIV = function ()
{
    // controls
    this.mEdgeOfScreenCheckbox.remove();
    this.mEdgeOfScreenCheckbox  = null;
    this.mDragWithMouseCheckbox.remove();
    this.mDragWithMouseCheckbox = null;
    this.mHardwareMouseCheckbox.remove();
    this.mHardwareMouseCheckbox = null;

    this.mContainer.empty();
    this.mContainer = null;
};


OptionsMenuModuleControlsPanel.prototype.setupEventHandler = function ()
{
   //this.removeEventHandler();

    this.mEdgeOfScreenCheckbox.on('ifChecked', null, this, function(_event) {
        var self = _event.data;
        self.mDataSource.updateControlsOption(OptionsMenuModuleIdentifier.QueryResult.Controls.Scrollmode.Key, OptionsMenuModuleIdentifier.QueryResult.Controls.Scrollmode.EdgeOfScreen);
    });

    this.mDragWithMouseCheckbox.on('ifChecked', null, this, function(_event) {
        var self = _event.data;
        self.mDataSource.updateControlsOption(OptionsMenuModuleIdentifier.QueryResult.Controls.Scrollmode.Key, OptionsMenuModuleIdentifier.QueryResult.Controls.Scrollmode.DragWithMouse);
    });

    this.mHardwareMouseCheckbox.on('ifChecked ifUnchecked', null, this, function(_event) {
        var self = _event.data;
        self.mDataSource.updateControlsOption(OptionsMenuModuleIdentifier.QueryResult.Controls.HardwareMouse, self.mHardwareMouseCheckbox.prop('checked') === true);
    });
};

/*
OptionsMenuModuleControlsPanel.prototype.removeEventHandler = function ()
{
    this.mEdgeOfScreenCheckbox.off('ifChecked ifUnchecked');
    this.mDragWithMouseCheckbox.off('ifChecked ifUnchecked');
    this.mHardwareMouseCheckbox.off('ifChecked ifUnchecked');
};
*/

OptionsMenuModuleControlsPanel.prototype.bindTooltips = function ()
{
	this.mEdgeOfScreenLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.EdgeOfScreen });
	this.mDragWithMouseLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.DragWithMouse });
	this.mHardwareMouseLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.HardwareMouse });
};

OptionsMenuModuleControlsPanel.prototype.unbindTooltips = function ()
{
	this.mEdgeOfScreenLabel.unbindTooltip();
	this.mDragWithMouseLabel.unbindTooltip();
	this.mHardwareMouseLabel.unbindTooltip();
};


OptionsMenuModuleControlsPanel.prototype.selectScrollmodeOptions = function(_data)
{
	if (_data === null || typeof(_data) !== 'string')
	{
		return;
	}

	switch(_data)
	{
		case OptionsMenuModuleIdentifier.QueryResult.Controls.Scrollmode.EdgeOfScreen:
		{
			this.mEdgeOfScreenCheckbox.iCheck('check');
		} break;
		case OptionsMenuModuleIdentifier.QueryResult.Controls.Scrollmode.DragWithMouse:
		{
			this.mDragWithMouseCheckbox.iCheck('check');
		} break;
	}
};

OptionsMenuModuleControlsPanel.prototype.selectHardwareMouseOption = function(_data)
{
	if (_data === null || typeof(_data) !== 'boolean')
	{
		return;
	}

	this.mHardwareMouseCheckbox.iCheck(_data === true ? 'check' : 'uncheck');
};


OptionsMenuModuleControlsPanel.prototype.registerDatasourceListener = function()
{
	this.mDataSource.addListener(OptionsMenuModuleDatasourceIdentifier.Options.Loaded, jQuery.proxy(this.onOptionsLoaded, this));
	this.mDataSource.addListener(OptionsMenuModuleDatasourceIdentifier.Options.Reseted, jQuery.proxy(this.onDefaultsLoaded, this));
};


OptionsMenuModuleControlsPanel.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

OptionsMenuModuleControlsPanel.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};


OptionsMenuModuleControlsPanel.prototype.register = function (_parentDiv)
{
    console.log('OptionsMenuModuleControlsPanel::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register Controls Panel Module. Reason: Controls Panel Module is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

OptionsMenuModuleControlsPanel.prototype.unregister = function ()
{
    console.log('OptionsMenuModuleControlsPanel::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister Controls Panel Module. Reason: Controls Panel Module is not initialized.');
        return;
    }

    this.destroy();
};

OptionsMenuModuleControlsPanel.prototype.isRegistered = function ()
{
	if (this.mContainer !== null)
	{
		return this.mContainer.parent().length !== 0;
	}

	return false;
};


OptionsMenuModuleControlsPanel.prototype.show = function ()
{
	this.mContainer.removeClass('display-none').addClass('display-block');
};

OptionsMenuModuleControlsPanel.prototype.hide = function ()
{
	this.mContainer.removeClass('display-block').addClass('display-none');
};


OptionsMenuModuleControlsPanel.prototype.onOptionsLoaded = function (_dataSource, _data)
{
	// get controls options
	var controlsOptions = _dataSource.getControlsOptions();
	if (OptionsMenuModuleIdentifier.QueryResult.Controls.Scrollmode.Key in controlsOptions)
	{
		this.selectScrollmodeOptions(controlsOptions[OptionsMenuModuleIdentifier.QueryResult.Controls.Scrollmode.Key]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Controls.HardwareMouse in controlsOptions)
	{
		this.selectHardwareMouseOption(controlsOptions[OptionsMenuModuleIdentifier.QueryResult.Controls.HardwareMouse]);
	}
};

OptionsMenuModuleControlsPanel.prototype.onDefaultsLoaded = function (_dataSource, _data)
{
	// get controls options
	var controlsOptions = _dataSource.getControlsOptions();
	if (OptionsMenuModuleIdentifier.QueryResult.Controls.Scrollmode.Key in controlsOptions)
	{
		this.selectScrollmodeOptions(controlsOptions[OptionsMenuModuleIdentifier.QueryResult.Controls.Scrollmode.Key]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Controls.HardwareMouse in controlsOptions)
	{
		this.selectHardwareMouseOption(controlsOptions[OptionsMenuModuleIdentifier.QueryResult.Controls.HardwareMouse]);
	}
};