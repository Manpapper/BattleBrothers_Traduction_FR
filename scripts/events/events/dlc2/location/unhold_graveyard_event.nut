this.unhold_graveyard_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.unhold_graveyard";
		this.m.Title = "En approchant...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_117.png[/img]{Des os de doigts comme des totems tombés, des cuisses arrachées des genoux comme si des forestiers s\'étaient attelés à un travail lugubre, des côtes incurvées éparpillées sur la terre comme si elles avaient été expertisées par un charpentier de marine, et les crânes, dont les mâchoires chancelaient, se dressaient comme des demeures animistes de chamans, des molaires de la taille d\'un bouclier où n\'importe quel homme pourrait y ramper à travers ses cavités.\n\n En regardant au-delà des restes squelettiques, vous en trouvez beaucoup d\'autres qui s\'étendent dans la vallée. Les os les plus lourds restent là où le souffle de leur propriétaire les a conduits en dernier lieu, tandis que les plus petits ont depuis longtemps roulé jusqu\'au fossé de la vallée et s\'y sont déposés dans un mélange de blanc teinté de chair et de fourrure.\n\nVous n\'avez aucune raison de croire que personne d\'autre que les monstres eux-mêmes ont manigancé leur perte ici. La violence n\'est pas dans leurs habitudes. Ils sont assis ou couchés dans des étreintes paisibles, %randombrother% signale qu\'un géant immense semble s\'être récemment couché. Il est niché dans un recoin, les mains posées sur ses genoux et la tête inclinée sur une épaule. Il a regardé le coucher du soleil, et le fera pour de nombreuses années à venir. Mais vous vous en foutez. Vous ordonnez aux hommes de se disperser et de ramasser ce qu\'ils peuvent. Certains de ces os, peaux ou autres qu\'ils ont apportés pourraient être d\'une grande utilité pour la compagnie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prenez tout.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(5);
				local item;
				item = this.new("scripts/items/misc/unhold_bones_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/unhold_bones_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/unhold_bones_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/unhold_hide_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/frost_unhold_fur_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

