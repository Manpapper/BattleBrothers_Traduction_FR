this.world_screen_topbar_ambition_module <- this.inherit("scripts/ui/screens/ui_module", {
	m = {},
	function clearEventListener()
	{
	}

	function create()
	{
		this.m.ID = "TopbarAmbitionModule";
		this.ui_module.create();
	}

	function destroy()
	{
		this.clearEventListener();
		this.ui_module.destroy();
	}

	function setText( _text )
	{
		this.m.JSHandle.asyncCall("setText", _text);
	}

	function onRequestCancel()
	{
		if (!this.World.Ambitions.hasActiveAmbition())
		{
			return;
		}

		this.World.State.showDialogPopup("Annuler Ambition", "Annuler une ambition vous permettra d\'en choisir une nouvelle, mais votre estime en tant que chef en prendra un coup ce qui laissera vos hommes désappointés.\n\nÊtes vous sûr de vouloir annuler l\'ambition?", this.onCancelAmbition.bindenv(this), null);
	}

	function onCancelAmbition()
	{
		this.World.Ambitions.cancelAmbition();
	}

});

