this.sellsword_retires_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null
	},
	function create()
	{
		this.m.ID = "event.sellsword_retires";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Alors que vous êtes sur le chemin, vous rencontrez un homme assis à côté du chemin. Il est vêtu d\'une armure usée et une arme encore plus usée est posée sur ses genoux. Il vous regarde avec le plus mou des saluts.%SPEECH_ON%bonsoir. Si vous n\'êtes pas des mercenaires, alors je n\'ai jamais mis le feu au pantalon de mon père.%SPEECH_OFF%Cela semble être une histoire intéressante en soi, mais vous demandez plutôt à l\'homme ce qu\'il fait au milieu de la route. Plus important encore, vous demandez à cet homme plutôt bien portant s\'il cherche du travail.%SPEECH_ON% Un travail ? Non. Je n\'en ai pas besoin. J\'ai déjà fait le coup de l\'épée et j\'en ai fini avec ça. Tu sais quoi, tiens.%SPEECH_OFF%Il commence à défaire son armure et la jette sur le sol devant toi.%SPEECH_ON%Prends la. Je n\'ai plus besoin de cette vie. Prends l\'arme, aussi. Je laisse toute cette merde derrière moi. Tu devrais, aussi, mais je sais que tu ne le feras pas. Pas avant qu\'il ne soit trop tard, en tout cas. Je vais parcourir la terre jusqu\'à ce que mes pieds soient réduits en bouillie. Quant à toi, bon vent. Et juste comme ça, l\'étranger s\'en va.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bonne chance.",
					function getResult( _event )
					{
						if (_event.m.Peddler != null)
						{
							return "B";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
				local item;
				local stash = this.World.Assets.getStash();
				item = this.new("scripts/items/weapons/arming_sword");
				item.setCondition(item.getConditionMax() / 2 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/armor/basic_mail_shirt");
				item.setArmor(item.getArmorMax() / 2 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%peddler% Le colporteur, qui a toujours un bon flair pour l\'or, demande à l\'homme s\'il a gagné des couronnes en travaillant comme mercenaire. Lorsque l\'étranger acquiesce, le colporteur fait remarquer que si c\'est vrai, il peut toujours acheter son retour dans la vie. Le mercenaire réfléchit une minute, puis hoche à nouveau la tête.%SPEECH_ON%Vous savez quoi ? C\'est vrai. Tant que j\'ai les couronnes, j\'ai toujours un moyen de revenir à ce maudit business. Tiens, prends-le.%SPEECH_OFF%Le retraité, et apparemment futur héritier, fouille dans ses poches et te lance joyeusement un sac de couronnes comme un homme qui se débarrasse d\'un vieux fardeau.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous en ferons bon usage.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				local money = this.Math.rand(20, 100);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crown"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Peddler = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"peddler",
			this.m.Peddler != null ? this.m.Peddler.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Peddler = null;
	}

});

