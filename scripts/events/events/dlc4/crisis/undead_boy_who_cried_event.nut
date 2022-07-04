this.undead_boy_who_cried_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Refusals = 0
	},
	function create()
	{
		this.m.ID = "event.undead_boy_who_cried";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 140.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{En visitant %townname%, vous êtes interpellé par un jeune garçon qui vient pleurer car des morts-vivants viennent de manger sa famille. Vous demandez combien ils sont et il dit qu\'il n\'y en a qu\'un, mais qu\'il est de souche mortelle.%SPEECH_ON%Je pense que c\'est mon ancienne baby-sitter. Elle ne s\'est jamais intéressée à moi. S\'il vous plaît, à l\'aide!%SPEECH_OFF%Si ce n\'est qu\'un seul wiederganger, cela ne devrait pas poser trop de problèmes et vous pouvez probablement vous en occuper vous-même.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Conduis-nous à ta maison, petit.",
					function getResult( _event )
					{
						return "Accept1A";
					}

				},
				{
					Text = "Tu te débrouilles tout seul, petit.",
					function getResult( _event )
					{
						++_event.m.Refusals;
						return "Refuse" + _event.m.Refusals;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Accept1A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Vous vous précipitez chez le garçon et passez la porte. Vous trouvez sa famille en train de préparer la table du dîner. Ils vous regardent comme si vous étiez un fou et l\'un d\'eux demande s\'il peut vous aider. Le garçon se met à rire si fort qu\'il se serre le ventre et se roule par terre. La mère l\'attrape par l\'oreille. Elle s\'excuse en le remettant à son père pour un bon coup de fouet.%SPEECH_ON%Désolé, mercenaire, nous ne voulons pas d\'ennuis mais ce garçon, eh bien, il en fait qu\'à sa tête parfois.%SPEECH_OFF%On ne peut pas vraiment reprocher à un garçon d\'être un garçon, bien que celui-ci soit un petit merdeux. Vous retournez vers les marchés.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très drôle.",
					function getResult( _event )
					{
						return "Accept1B";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
			}

		});
		this.m.Screens.push({
			ID = "Accept1B",
			Text = "[img]gfx/ui/events/event_01.png[/img]{Alors que vous parcourez les étales d\'un marchand, une petite voix vous interpelle. En se retournant, vous voyez que c\'est encore ce satané gamin. Il pointe vers la maison une fois de plus.%SPEECH_ON%Mercenaire! L\'un d\'eux est là! Je suis sérieux! Vous devez m\'aider!%SPEECH_OFF%Vous demandez pourquoi il ne dérange pas un des gardes et il répond qu\'aucun ne lui fait confiance.%SPEECH_ON%Je leur ai fait gober trop de mensonges! S\'il vous plaît, à l\'aide! Ma famille va être massacrée!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord, d\'accord, allons-y.",
					function getResult( _event )
					{
						return "Accept2A";
					}

				},
				{
					Text = "Tu te débrouilles tout seul, petit.",
					function getResult( _event )
					{
						++_event.m.Refusals;
						return "Refuse" + _event.m.Refusals;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Accept2A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{En soupirant, vous dites au garçon de vous montrer le chemin. Surprise, surprise, on s\'est encore moqué de vous. Le garçon ne peut s\'empêcher de rire même si son père lui donne un bon coup de fouet. La mère, une fois de plus, s\'excuse et vous remet un petit sac de marchandises pour votre peine. Vous repartez vers les marchés.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est toujours mieux que rien.",
					function getResult( _event )
					{
						return "Accept2B";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
				local item = this.new("scripts/items/supplies/roots_and_berries_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Accept2B",
			Text = "[img]gfx/ui/events/event_01.png[/img]{Alors que vous êtes de retour au marché, vous vous attendez déjà à ce que ce petit menteur revienne vous voir. Vous faites semblant d\'être choqué quand il tire sur votre main. Un ange passe, puis vous vous imaginez frapper le gamin en plein dans la mâchoire. Bien sûr, cela n\'aurait pas l\'air bien pour ceux qui ne connaissent pas l\'histoire, alors vous restez tranquille.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mince, je me demande comment ça va se passer.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "Accept3A" : "Accept3B";
					}

				},
				{
					Text = "Cours avant de te faire battre, mon garçon!",
					function getResult( _event )
					{
						++_event.m.Refusals;
						return "Refuse" + _event.m.Refusals;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Accept3A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Avec prudence, vous retournez à la maison du garçon. À la seconde où la porte s\'ouvre, la famille est en train de jouer aux cartes, vous vous retournez, attrapez le gamin par la gorge et le plaquez contre le mur. Vous fermez la porte d\'un coup de pied pour que personne ne puisse voir. Le père se lève et dit que c\'est son fils que vous malmenez. Vous dites au père de donner le fouet utilisé pour battre son garçon. Avec prudence, il fait ce qu\'on lui dit. Cette fois-ci, c\'est vous qui punissez le gamin, il fini couvert de bleus, en larme.\n\nVous jetez le fouet sur l\'enfant et dites aux parents de payer, en les informant qu\'un \"mercenaire ne travaille jamais gratuitement.\"}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Des sanctions ont dû être prises.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(10);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + 10 + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Accept3B",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Avec prudence, vous retournez à la maison du garçon. En ouvrant la porte, vous vous tournez vers le garçon et lui dites que s\'il ment encore une fois, vous allez... avant même que vous puissiez terminer la menace, un cri attire votre attention sur la famille. Une grande silhouette macabre terrorise la mère, le père utilise un balai pour essayer de la repousser. Vous dégainez votre épée en avançant, et vous abattez le wiederganger. Sa tête se détache et éclabousse une mijoteuse tandis que le corps s\'effondre et crache de la boue noire sur le plancher.\n\n Vous vous tournez vers le garçon et lui dites que vous avez failli ne pas venir... La vérité du garçon restera toujours un mensonge pour la plupart des gens. Il acquiesce et vous remercie de l\'avoir cru cette fois-ci. Les parents vous remercient aussi, mais avec un peu plus d\'attention: une sacoche de couronnes et de marchandises.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il vaut mieux jeter cette mijoteuse.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
				this.World.Assets.addMoney(25);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + 25 + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Refuse1",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Vous vous méfiez du petit avorton et lui dites d\'arrêter de jouer. Il crache et met des coups de pied dans une pierre.%SPEECH_ON%Merde, monsieur, j\'essayais de m\'amuser.%SPEECH_OFF%Quand il se retourne pour partir, vous lui donnez un coup de pied rapide dans le cul.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maudit avorton.",
					function getResult( _event )
					{
						return "Accept" + _event.m.Refusals + "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Refuse2",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Vous dites au garçon que s\'il ne disparaît pas de votre vue, vous le dénoncerez aux gardes et le ferez jeter dans les cachots. Il s\'énerve et crache.%SPEECH_ON%Merde, monsieur, je rigole un peu, c\'est tout.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et ne reviens pas.",
					function getResult( _event )
					{
						return "Accept" + _event.m.Refusals + "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Refuse3",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Vous vous accroupissez pour que le gamin et vous puissiez vous regarder dans les yeux. Vous lui demandez s\'il ment. Lentement, il acquiesce. Un garde, qui a entendu cela, s\'approche et attrape l\'enfant par le bras.%SPEECH_ON%Oh, on ment encore, n\'est-ce pas ? Qu\'est-ce que je t\'ai dit sur le fait d\'importuner les voyageurs, hm ? Si tu recommences, c\'est que ton père n\'y est pas aller assez fort. Maintenant nous allons voir comment tu t\'en sors dans les cachots!%SPEECH_OFF%Le garçon est emmené, les yeux écarquillés alors qu\'on lui met des menottes rouillées. C\'est l\'un des plus beaux jours de votre vie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Profite bien du cachot.",
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
			ID = "Refuse3B",
			Text = "[img]gfx/ui/events/event_29.png[/img]{Vous dites au garçon d\'aller voir ailleurs. Il supplie encore et, pendant un moment, c\'est comme si quelque chose de réel se cachait derrière ses yeux de menteur. Mais vous n\'y croyez pas. Le garçon s\'enfuit, demandant maintenant de l\'aide aux gardes. Ils refusent également de l\'aider. Quelques marchands rient.%SPEECH_ON%Personne ne croit à tes mensonges, petit avorton.%SPEECH_OFF%Mais un cri coupe court à cette plaisanterie. Un homme traverse la rue en boitant, serrant son cou qui gicle de sang entre ses doigts. Il s\'effondre sur le sol. Une femme au teint blafard se lance à sa poursuite, tombe sur le corps de l\'homme et lui mord la jambe. Les gardes se précipitent sur la scène et massacrent le mort et la mourante tandis que le nouvel orphelin hurle.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oh.",
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.FactionManager.getGreaterEvilType() != this.Const.World.GreaterEvilType.Undead || this.World.FactionManager.getGreaterEvilPhase() == this.Const.World.GreaterEvilPhase.NotSet)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

