this.apotheosis_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.apotheosis_potion";
		this.m.Name = "Potion de l'Apothéose";
		this.m.Description = "Cette concoction fantastique est le summum de ce que la recherche sur l'anatomie humaine a produit. Les rares initiés qui en connaissent l'existence prétendent que la consommer revient à accéder à un état supérieur de l'être, quelque chose au-delà d'un simple humain.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_10.png";
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
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] Points de vie"
		});
		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] Fatigue"
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

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		_actor.getSkills().add(this.new("scripts/skills/effects/apotheosis_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

