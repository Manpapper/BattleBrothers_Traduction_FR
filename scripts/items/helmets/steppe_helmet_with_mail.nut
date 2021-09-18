this.steppe_helmet_with_mail <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.steppe_helmet_with_mail";
		this.m.Name = "Steppe Helmet with Mail";
		this.m.Description = "A nasal helmet witch an attached mail neck guard fashioned in the way of the steppe folks.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			199,
			199,
			199,
			199,
			199,
			199,
			199,
			207,
			208,
			209,
			210,
			211
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 1250;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -12;
		this.m.Vision = -2;
	}

	function setPlainVariant()
	{
		this.setVariant(199);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 199;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 207;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 210;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 211;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 209;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 208;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

