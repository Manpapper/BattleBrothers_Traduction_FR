this.honor_guard_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.honor_guard_potion";
		this.m.Name = "Élixir d'Os et de Chair";
		this.m.Description = "Les morts-vivants sont à juste titre craints pour leur dessein inflexible et leur volonté inébranlable, mais tout guerrier expérimenté connaît une troisième horreur, la résistance redoutable de ces créatures aux lances et aux flèches. Avec cette concoction, les vivants peuvent acquérir un tel aegis également !";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_19.png";
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
			text = "Prenez entre [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color] et [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] de dégâts en moins des attaques perforantes, telles que celles provenant d'arcs ou de lances"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/honor_guard_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

