this.battle_standard_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.battle_standard";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous avons besoin d\'un étendard pour être reconnu de loin ! Faire fabriquer un étendard est coûteux, nous devons donc réunir 2 000 couronnes pour cela.";
		this.m.RewardTooltip = "Vous recevrez un objet unique qui donne de la détermination supplémentaire à tous ceux qui se trouvent à proximité du porteur.";
		this.m.UIText = "Ayez au moins 2 000 couronnes";
		this.m.TooltipText = "Rassemblez la somme de 2 000 couronnes ou plus, afin de pouvoir vous permettre de faire fabriquer un étendard pour la compagnie. Vous pouvez gagner de l\'argent en remplissant des contrats, en pillant des camps et des ruines, ou en faisant du commerce. Vous aurez également besoin d\'un espace suffisant dans votre inventaire pour le nouvel objet.";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]Personne n\'aime les radins, et encore moins un groupe de vagabonds sanguinaires motivés principalement par l\'amour de l\'argent. Tout le monde, ou plus précisément personne, n\'a été ravi lorsque vous avez suggéré de réduire les dépenses pour économiser pour un étendard de la compagnie.\n\n Une fois que l\'étendard de %companyname% est enfin payé et hissé pour la première fois pour claquer fièrement dans la brise de l\'aube, personne ne prétend que ça ne valait pas la peine. Les hommes sont fiers de leur nouvel étendard, ils vont même jusqu\'à lui donner des noms autour du feu de camp, bien qu\'aucuns d\'entre eux ne tiennent vraiment la route. \n\nC\'est clair pour tout le monde maintenant, il ne s\'agit pas d\'une bande de voyous engagés, c\'est en train de devenir une véritable compagnie de mercenaires. Qui devrait avoir l\'honneur de porter l\'étendard ?";
		this.m.SuccessButtonText = "Les hommes, ce sont nos couleurs maintenant !";
	}

	function onUpdateScore()
	{
		if (this.World.Ambitions.getDone() < 1)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 2000 && this.World.Assets.getStash().hasEmptySlot())
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		this.World.Assets.addMoney(-1000);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/asset_money.png",
			text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]1,000[/color] Couronnes"
		});
		item = this.new("scripts/items/tools/player_banner");
		item.setVariant(this.World.Assets.getBannerID());
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

