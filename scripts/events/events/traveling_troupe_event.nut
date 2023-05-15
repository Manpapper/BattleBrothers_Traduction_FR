this.traveling_troupe_event <- this.inherit("scripts/events/event", {
	m = {
		Entertainer = null,
		Noble = null,
		Payment = 0
	},
	function create()
	{
		this.m.ID = "event.traveling_troupe";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]Alors que vous campez au bord de la route, un chariot coloré s\'avance avec une sorte d\'immodestie musicale cliquetante et tintante. Vous ne pensiez pas qu\'il s\'agissait d\'un chariot particulièrement grand, mais une quinzaine d\'hommes et de femmes en sorte. Visages peints, instruments de musique, balles de jonglage, épées pour avaler, cruches à vin pour cracher du feu, la troupe de comédiens se déploie et fait des démonstrations de mini-talents comme si vous aviez déjà payé pour leurs services. Lorsqu\'ils ont terminé, ils applaudissent, tapent du pied et se figent devant vous, les mains tendues, le sourire aux lèvres. Un mime au visage blanc prend la parole avec ironie. %SPEECH_ON% Que dites-vous, voyageurs, d\'un spectacle ? Une modique somme de %payment% couronnes pour vous divertir toute la soirée!%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bien sûr, on va payer pour un spectacle.",
					function getResult( _event )
					{
						return "Regular";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Entertainer != null)
				{
					this.Options.push({
						Text = "%entertainerfull%, qu\'en dis-tu ?",
						function getResult( _event )
						{
							return "Entertainer";
						}

					});
				}

				if (_event.m.Noble != null)
				{
					this.Options.push({
						Text = "On dirait que tu as quelque chose en tête, %noblefull%.",
						function getResult( _event )
						{
							return "Noble";
						}

					});
				}

				this.Options.push({
					Text = "Et si vous nous remettiez vos objets de valeur ?",
					function getResult( _event )
					{
						return "Robbing";
					}

				});
				this.Options.push({
					Text = "C\'est bon, merci.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Entertainer",
			Text = "[img]gfx/ui/events/event_26.png[/img]%entertainer% s\'avance et prend certains des outils de travail de la troupe. Il les teste, impressionnant les artistes par la façon dont il est capable d\'utiliser leur propre équipement. Le mime demande s\'ils pourraient jouer quelques tours avec lui. Il acquiesce et se joint aux artistes, offrant un spectacle inoubliable. Quand tout est fini, la troupe est tellement impressionnée qu\'elle essaie de recruter l\'homme. Vous leur dites que ce n\'est pas possible et %entertainer% acquiesce.%SPEECH_ON%Mon temps est avec %companyname% maintenant, mais j\'apprécie le compliment.%SPEECH_OFF%Vous demandez combien pour le spectacle, mais le chef de la troupe secoue la tête.%SPEECH_ON% Pas besoin. C\'était un plaisir de jouer avec lui. Nous n\'avons pas fait un tel spectacle depuis longtemps et l\'entraînement nous a fait du bien.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au revoir.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Entertainer.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.0, "Divertis par une troupe itinérante");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Noble",
			Text = "[img]gfx/ui/events/event_26.png[/img]Avant que la troupe ne puisse commencer, %nobleman% le noble se lève et demande s\'ils connaissent une chanson particulière de son époque à la cour.%SPEECH_ON%Ils la chantaient quand j\'étais petit. Cela fait des années que je ne l\'ai pas entendue.%SPEECH_OFF%Le mime, qui sort à nouveau de son personnage, sourit et proclame haut et fort qu\'ils la connaissent. Il claque des doigts et les musiciens du groupe prennent leurs instruments. Lorsqu\'ils commencent, la mélodie est immédiatement entraînante. C\'est une orchestration de cordes et de cornes, jouée aux côtés d\'une grande femme qui chante à la fois avec son cœur et son ventre. C\'est une chanteuse de tempête, qui apporte à la fois le calme et la férocité d\'une grande tempête, et ses paroles sont celles d\'un incroyable héroïsme d\'antan. Après que la troupe ait terminé, vous demandez combien vous leur devez. Le mime secoue la tête. Non, monsieur, le paiement n\'est pas nécessaire.%SPEECH_ON%Cela fait longtemps qu\'on ne l\'a pas demandé et c\'était un plaisir de le jouer pour vous.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Magnifique.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.0, "Divertis par une troupe itinérante");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Robbing",
			Text = "[img]gfx/ui/events/event_60.png[/img]Vous ordonnez la descente de la troupe. Le mime, cette fois-ci réellement dans son personnage, lève les mains et dit \"quoi ?\". Mais l\'espièglerie est effacée lorsque %randombrother% s\'avance et lui plante un coup de poing en plein dans le menton. Le mime s\'écroule avec un cri de chat, miaulant dans la boue en soignant sa mâchoire. Le reste de la compagnie assomme la troupe en pillant leur chariot de marchandises. Un jongleur reçoit un coup de pied dans les couilles et une chanteuse a la gorge tranchée par la main de son frère. L\'avaleur d\'épée tente de cacher son épée au seul endroit qu\'il connaît, mais un mercenaire la récupère avec un dégainage plutôt douloureux. Le cracheur de feu boit la totalité de sa cruche puis demande si tu veux la prendre aussi. Vous l\'avez frappé à l\'estomac pour son sarcasme. Quand tout est dit et fait, il n\'y a vraiment pas grand chose à prendre car tabasser des bouffons n\'est pas le business le plus rentable. Au moins, avec une bouche cassée, peut-être que le mime fera mieux son travail.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Apprends à mimer, espèce d\'enfoiré.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				local item = this.new("scripts/items/helmets/jesters_hat");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/lute");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(50, 200);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getBackground().getID() == "background.raider")
					{
						bro.improveMood(1.0, "A aimé battre une troupe itinérante");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Regular",
			Text = "[img]gfx/ui/events/event_26.png[/img]Vous payez pour un spectacle que la troupe présente plutôt bien. Les bouffons font des blagues, les jongleurs jonglent, ce qui est un peu démodé mais peu importe, les chanteurs chantent, les épées sont avalées, le feu \"craché\", et le mime, eh bien, il est affreux et vous espérez vraiment qu\'il meure. Quand tout est dit et fait, vous avez l\'impression d\'en avoir eu pour votre argent et les hommes sont heureux.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Merci.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-_event.m.Payment);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Payment + "[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.0, "Divertis par une troupe itinérante");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (this.World.Assets.getMoney() < 40 * brothers.len() + 500)
		{
			return;
		}

		local candidates_entertainer = [];
		local candidates_noble = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.juggler" || bro.getBackground().getID() == "background.minstrel")
			{
				candidates_entertainer.push(bro);
			}
			else if (bro.getBackground().getID() == "background.adventurous_noble" || bro.getBackground().getID() == "background.disowned_noble" || bro.getBackground().getID() == "background.regent_in_absentia")
			{
				candidates_noble.push(bro);
			}
		}

		if (candidates_entertainer.len() != 0)
		{
			this.m.Entertainer = candidates_entertainer[this.Math.rand(0, candidates_entertainer.len() - 1)];
		}

		if (candidates_noble.len() != 0)
		{
			this.m.Noble = candidates_noble[this.Math.rand(0, candidates_noble.len() - 1)];
		}

		this.m.Payment = 40 * brothers.len();
		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"entertainer",
			this.m.Entertainer != null ? this.m.Entertainer.getNameOnly() : ""
		]);
		_vars.push([
			"entertainerfull",
			this.m.Entertainer != null ? this.m.Entertainer.getName() : ""
		]);
		_vars.push([
			"nobleman",
			this.m.Noble != null ? this.m.Noble.getNameOnly() : ""
		]);
		_vars.push([
			"noblefull",
			this.m.Noble != null ? this.m.Noble.getName() : ""
		]);
		_vars.push([
			"payment",
			this.m.Payment
		]);
	}

	function onClear()
	{
		this.m.Entertainer = null;
		this.m.Noble = null;
		this.m.Payment = 0;
	}

});

