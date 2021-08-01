this.butcher_wardogs_event <- this.inherit("scripts/events/event", {
	m = {
		Butcher = null
	},
	function create()
	{
		this.m.ID = "event.butcher_wardogs";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_27.png[/img]Vous ouvrez une caisse de nourriture pour trouver la dernière de vos réserves. Une pomme roule au fond, et son bruit n\'est pas sans rappeler le grognement d\'un estomac vide. Quelques miches de pain lui tiennent compagnie et il y a un morceau de viande enveloppé dans une feuille épaisse. C\'est tout.\n\nQuand vous fermez le couvercle et vous retournez, %butcher% le boucher se tient là.%SPEECH_ON%Hé là, boss. Je vois que nous avons un problème. Alors que diriez-vous que je... le règle ?%SPEECH_OFF%À ce moment-là, il jette un coup d\'œil par-dessus son épaule, en direction de deux chiens de guerre enchaînés à un poteau.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faites ce qui est nécessaire.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Je ne laisserai pas nos fidèles chiens être massacrés et mangés.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_14.png[/img]Les chiens sont assis studieusement, haletants et semblent plutôt satisfaits, tant leur bonheur est durable. Mais vous avez des bouches à nourrir et des batailles à mener. Vous donnez à %butcher% le feu vert pour faire ce qui est bon pour la compagnie.\n\nLe boucher se dirige vers les cabots, tendant une main pour les caresser tandis que l\'autre serre un couteau derrière son dos. Vous ne restez pas dans les parages pour voir ce qui se passe ensuite, mais un bref glapissement rapidement suivi d\'un autre retourne votre estomac déjà vide.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au moins les hommes n\'auront pas faim ce soir.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				local numWardogsToSlaughter = 2;
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
					{
						numWardogsToSlaughter = --numWardogsToSlaughter;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Vous perdez " + item.getName()
						});

						if (numWardogsToSlaughter == 0)
						{
							break;
						}
					}
				}

				if (numWardogsToSlaughter != 0)
				{
					local brothers = this.World.getPlayerRoster().getAll();

					foreach( bro in brothers )
					{
						local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

						if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
						{
							numWardogsToSlaughter = --numWardogsToSlaughter;
							bro.getItems().unequip(item);
							this.List.push({
								id = 10,
								icon = "ui/items/" + item.getIcon(),
								text = "Vous perdez " + item.getName()
							});

							if (numWardogsToSlaughter == 0)
							{
								break;
							}
						}
					}
				}

				local item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_27.png[/img]Vous secouez la tête pour dire non.%SPEECH_ON%Absolument pas. Ils font partie de la compagnie au même titre que n\'importe quel homme, et il est certain que certains hommes préféreraient mourir de faim plutôt que de manger l\'un des leurs.%SPEECH_OFF%Le boucher hausse les épaules.%SPEECH_ON%Ce ne sont que des chiens, monsieur. Des bâtards. Des molosses. Ce n\'est rien d\'autre qu\'une bête qui connaît son nom et rien d\'autre. Il y a plein de chiots à trouver quand on en a besoin.%SPEECH_OFF%Encore une fois, vous secouez la tête.%SPEECH_ON%On ne tuera pas les chiens, %butcher%. Et ne crois pas que je ne vois pas la lueur dans tes yeux. C\'est plus que juste abattre ces animaux seulement pour nourrir quelques bouches.%SPEECH_OFF%%butcher% ne peut que hausser les épaules à nouveau.%SPEECH_ON%Je ne peux pas choisir ce qui me fait plaisir, monsieur, mais je vais suivre vos ordres.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous trouverons autre chose.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				_event.m.Butcher.worsenMood(1.0, "Was denied a request");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Butcher.getMoodState()],
					text = _event.m.Butcher.getName() + this.Const.MoodStateEvent[_event.m.Butcher.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getFood() > 25)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local numWardogs = 0;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.butcher")
			{
				candidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
			{
				numWardogs = ++numWardogs;
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		if (numWardogs < 2)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
				{
					numWardogs = ++numWardogs;

					if (numWardogs >= 2)
					{
						break;
					}
				}
			}
		}

		if (numWardogs < 2)
		{
			return;
		}

		this.m.Butcher = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"butcher",
			this.m.Butcher.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Butcher = null;
	}

});

