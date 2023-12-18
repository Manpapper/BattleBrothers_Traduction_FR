this.alp_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.Name = "Élixir du Roi de la Nuit";
		this.m.Description = "Cet élixir, fruit d'une étude intensive du prétendu 'Troisième Œil' de l'Alp, permet à quiconque le boit de voir à travers la nuit comme s'il faisait jour ! Vision floue et hallucinations sont à prévoir pendant que le corps s'acclimate.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_34.png";
		this.m.Value = 0;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Non affecté par les pénalités nocturnes"
		});
		result.push({
			id = 65,
			type = "text",
			text = "Cliquez avec le bouton droit ou faites glisser sur le personnage actuellement sélectionné pour boire. Cet objet sera consommé dans le processus."
		});
		result.push({
			id = 65,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "Mutile le corps, provoquant la maladie"
		});
		return result;
	}

	function onUse( _actor, _item = null )
	{
		_actor.getSkills().add(this.new("scripts/skills/effects/alp_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

