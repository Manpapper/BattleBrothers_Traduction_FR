this.geist_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.geist_potion";
		this.m.Name = "Breuvage du Mort";
		this.m.Description = "Cette concoction, synthétisée à partir des faibles résidus ectoplasmiques d'un Geist 'tué', modifie le corps de celui qui la boit pour prendre un aspect spectral similaire. Toutes les armes maniées par un tel guerrier gagneront sûrement une partie de la capacité de la créature à contourner l'armure ! Des hallucinations auditives sont un effet secondaire attendu de la consommation du breuvage et cesseront probablement après un certain temps. Enfin, on l'espère.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_24.png";
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
			text = "Un [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color] supplémentaire des dégâts ignore l'armure lors de l'utilisation d'armes de mêlée"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/geist_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

