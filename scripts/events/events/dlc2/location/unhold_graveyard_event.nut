this.unhold_graveyard_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.unhold_graveyard";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_117.png[/img]{Fingerbones like fallen totems, thighs hewn free of the knees as though foresters had set upon a gloomy work, curved ribs scattered across the earth like they were under a shipwright\'s appraisal, and the skulls, tottering on the wedges of jawbones, held up like animistic abodes of shamans, molars the size of shields and any man could crawl through its eye sockets.\n\n Looking past the unhold\'s skeletal remains, you find plenty more fanning out into a valley. The heaviest of the bones stay where their owner\'s breath had last ushered them, while the smallest of the sort have long since rolled to the valley ditch and settled there in a wash of white wimpled with whatever flesh and fur remains.\n\nYou\'ve no reason to believe that none other than the unholds themselves plotted their demise here. Violence is not in their shapes. They are sitting up or laying down in peaceful eternities, and indeed %randombrother% points out a great giant which seems to have recently laid itself to rest. It is nestled into an earthen nook with its hands wrapped over its knees and its head tilted on a shoulder. It watched the sunset, and will do so for many years to come. Not that you care. You order the men to fan out and collect what they can. Some of these bones or pelts or what else they\'ve brought could be of great use to the company.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take everything.",
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
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/unhold_bones_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/unhold_bones_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/unhold_hide_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/frost_unhold_fur_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
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

