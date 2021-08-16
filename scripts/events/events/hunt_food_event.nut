this.hunt_food_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.hunt_food";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_10.png[/img]{Alors que vous aidez %otherguy% à sortir sa botte de la boue, %hunter% sort des buissons avec ce qui doit être une douzaine de lapins attachés ensemble. Il les dépose et commence à les détacher. Les petits lapins - les yeux écarquillés, horrifiés jusqu\'à la fin - ont tous l\'air assez savoureux. Le chasseur en attrape un par le cou et lui fait tord le corps d\'un coup sec avant de lui faire sortir tous ses boyaux. Il répète ce processus jusqu\'à ce que chaque lapin ait été tué. Tout en s\'essuyant la main sur la cape de %otherguy%, le chasseur montre le tas de lapins vidés à ses pieds : %SPEECH_ON% C\'est le tas à manger. %SPEECH_OFF% Il montre ensuite le tas de tripes de lapin : %SPEECH_ON% Ce n\'est pas le tas à manger. C\'est compris ? Bien.%SPEECH_OFF% | %hunter% a couru devant le groupe il y a quelques heures et vous venez de le rattraper. Il se tient debout, le pied sur un cerf mort, la poitrine transpercée par une seule flèche. Lorsque vous vous approchez, il sourit et s\'éloigne. Il dit que si certains des frères d\'armes peuvent aider à l\'attacher, il le dépouillera et le préparera. | Les oiseaux de la forêt gloussent et jacassent au-dessus de la compagnie. Le soleil cligne des yeux entre les branches de la canopée, une douce lueur qui parsème le sol de points lumineux. Vous apercevez un écureuil qui se repose dans l\'un des rayons du soleil, profitant de la chaleur tout en rongeant un gland. Il s\'arrête, sentant que vous l\'observez, puis il s\'agite soudainement et une tache de son sang rencontre votre joue. Vous l\'essuyez et vous vous retournez pour voir que l\'écureuil a été empalé par une flèche, chaque cri de mort étant plus silencieux que le précédent alors que sa vie le quitte lentement. %hunter% surgit soudain des buissons, un arc à la main et un sourire aux lèvres. Le chasseur récupère sa proie et la jette avec d\'autres, une longue ligne de chasse autour de laquelle sont attachées toutes sortes de créatures, ennemies ou amies.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "De bonnes choses à manger.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hunter.getImagePath());
				local food = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(food);
				this.List = [
					{
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "Vous recevez Gibier"
					}
				];
				_event.m.Hunter.improveMood(0.5, "A chassé avec succès");

				if (_event.m.Hunter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Hunter.getMoodState()],
						text = _event.m.Hunter.getName() + this.Const.MoodStateEvent[_event.m.Hunter.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.barbarian")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Hunter = candidates[this.Math.rand(0, candidates.len() - 1)];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Hunter.getID())
			{
				this.m.OtherGuy = bro;
				this.m.Score = candidates.len() * 10;
				break;
			}
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hunter",
			this.m.Hunter.getName()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onClear()
	{
		this.m.Hunter = null;
		this.m.OtherGuy = null;
	}

});

