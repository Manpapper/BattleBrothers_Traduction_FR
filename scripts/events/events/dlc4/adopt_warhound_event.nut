this.adopt_warhound_event <- this.inherit("scripts/events/event", {
	m = {
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.adopt_warhound";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Vous tombez sur une caldeira au fond de laquelle vous trouvez quelques moutons en train de câliner quelque chose. En vous approchant, vous voyez qu\'il y a là un énorme molosse, à la fourrure emmêlée de sang, au col déchiqueté et aux pattes déchiquetées là où les griffes se sont détachées. Il vous regarde avec un grognement, mais ne peut le maintenir longtemps car il baisse simplement la tête avec un souffle épuisé. Les moutons partent et derrière eux, vous trouvez un homme appuyé contre un rocher. Sa poitrine a été déchirée et ce qui l\'a tué l\'a fait avec une telle force que ses entrailles ont été projetées sur les rochers. En suivant la piste, vous trouvez un monstrueux Nachzehrer dont la gorge a été arrachée. %randombrother% hoche la tête.%SPEECH_ON%Je pense que ce chiot pourrait être utile dans la compagnie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il s\'adaptera parfaitement à nous.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Houndmaster != null)
				{
					this.Options.push({
						Text = "%houndman%, vous avez déjà eu affaire à des chiens de chasse, non ?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "Mettez fin à ses souffrances.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{Vous tendez la main au molosse et il lève la tête vers vous comme si vous étiez une autre menace. Ses yeux sont noirs et brillent dans une longue crinière qui dégouline encore de sang. Les moutons, qui ont vu le carnage que cette bête a déjà fait, s\'agitent nerveusement en vous regardant. Mais vous ne vous laissez pas décourager. Vous avancez votre main, paume en avant, et le chien fatigué s\'y abaisse lentement. Vous hochez la tête.%SPEECH_ON%Il y a encore du courage en toi, mon ami.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je t\'appellerai \"Guerrier\".",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/warhound_item");
				item.m.Name = "Guerrier le chien de guerre";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{Vous vous déplacez pour prendre le chien, mais alors que vous vous accroupissez, l\'un des moutons s\'approche et vous charge, vous renversant. Les hommes rient et le temps que vous vous mettiez à genoux, un autre mouton vous écrase par derrière sous les acclamations. En sortant votre épée, vous émettez un son aigu qui fait fuir le mouton. Quand vous vous retournez vers le chien, son nez est dans la terre et ses yeux sont sans égal. Il est mort et les moutons se rassemblent lentement autour de lui en bêlant et en criant. Vous rengainez votre épée et dites à la compagnie d\'avancer.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un petit gars courageux.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%{%houndman% s\'avance.%SPEECH_ON%Je connais cette race. Elle est de souche nordique, une créature robuste. Il y a une chose qu\'elle respecte chez un homme, c\'est la force.%SPEECH_OFF%Le mercenaire s\'accroupit devant le chien et, sans pause, met ses mains autour de l\'éraflure de son cou et commence à le gratter. Malgré les mouvements brusques, le chien réagit positivement et, lorsque l\'homme cesse de le gratter, il se soulève du sol et s\'avance à grands pas pour suivre l\'homme. %houndman% vous regarde fixement tandis qu\'il malmène le chien en le caressant fortement.%SPEECH_ON%Oui, il se battra pour nous. Il est fait pour se battre. Il avait juste besoin de quelqu\'un pour le regarder déchirer et arracher.%SPEECH_OFF%Quelle charmante créature. Et le chien est bien, aussi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Appelons-le \"Guerrier\" alors.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				local item = this.new("scripts/items/accessory/warhound_item");
				item.m.Name = "Guerrier le chien de guerre";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.7)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.houndmaster" || bro.getBackground().getID() == "background.barbarian")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Houndmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"houndman",
			this.m.Houndmaster != null ? this.m.Houndmaster.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Houndmaster = null;
	}

});

