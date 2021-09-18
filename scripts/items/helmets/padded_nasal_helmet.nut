this.padded_nasal_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.padded_nasal_helmet";
		this.m.Name = "Padded Nasal Helmet";
		this.m.Description = "A metal helmet with added noseguard and a padded coif underneath.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			2,
			2,
			2,
			2,
			2,
			2,
			2,
			92,
			93,
			94,
			95,
			169
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 550;
		this.m.Condition = 130;
		this.m.ConditionMax = 130;
		this.m.StaminaModifier = -7;
		this.m.Vision = -1;
	}

	function setPlainVariant()
	{
		this.setVariant(2);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 2;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 95;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 92;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 93;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 94;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 169;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

